require_relative '../../lib/hwacha'

RSpec.configure do |config|
  config.before :each do
    Typhoeus::Expectation.clear
  end
end

describe Hwacha, "initialization" do
  it "defaults to 20 max concurrent requests" do
    expect(Hwacha.new.config.max_concurrent_requests).to eq 20
  end

  it "takes an integer argument to set the number of max concurrent requests" do
    expect(Hwacha.new(10).config.max_concurrent_requests).to eq 10
  end

  it "can set max_concurrent_requests via a configuration object" do
    hwacha = Hwacha.new do |config|
      config.max_concurrent_requests = 10
    end
    expect(hwacha.config.max_concurrent_requests).to eq 10
  end
end

describe Hwacha, "Typhoeus configuration" do
  describe "#build_hydra" do
    context "when max_concurrent_requests is set" do
      subject do
        Hwacha.new do |config|
          config.max_concurrent_requests = max_concurrent_requests
        end
      end

      let(:max_concurrent_requests) { 10 }

      it "sets max_concurrency from max_concurrent_requests" do
        expect(subject.build_hydra.max_concurrency).to eq max_concurrent_requests
      end
    end
  end
end

describe Hwacha, "url checking" do
  let(:url_with_success_response) { 'rakeroutes.com' }
  let(:url_with_404_response) { 'rakeroutes.com/this-url-does-not-exist' }
  let(:not_a_url) { '' }
  let(:various_urls) do
    [url_with_success_response, url_with_404_response, not_a_url]
  end
  let(:http_200_response) do
    Typhoeus::Response.new({
      :code => 200,
      :body => "Hwacha!",
      :effective_url => "HTTP://#{url_with_success_response}/",
    })
  end
  let(:http_404_response) do
    Typhoeus::Response.new({
      :code => 404,
      :body => "404",
      :effective_url => "HTTP://#{url_with_404_response}/",
    })
  end

  before do
    Typhoeus.stub(url_with_success_response).and_return(http_200_response)
    Typhoeus.stub(url_with_404_response).and_return(http_404_response)
  end

  describe "#check" do
    it "yields when there is a successful web response" do
      expect { |probe| subject.check(url_with_success_response, &probe) }.to yield_control
    end

    it "yields when there is not a successful web response" do
      expect { |probe| subject.check(url_with_404_response, &probe) }.to yield_control
    end

    it "yields when there is no web response" do
      expect { |probe| subject.check(not_a_url, &probe) }.to yield_control
    end

    it "yields the checked URL" do
      subject.check(url_with_success_response) do |url, _|
        expect(url).to eq "HTTP://%s/" % url_with_success_response
      end
    end

    it "yields the web response" do
      subject.check(url_with_success_response) do |_, response|
        expect(response.success?).to be_true
      end
    end

    it "checks an array of urls and executes the block for each" do
      urls_checked = 0

      subject.check(various_urls) do |url, response|
        urls_checked += 1
      end

      expect(urls_checked).to eq various_urls.size
    end
  end

  describe "#find_existing" do
    it "yields when there is a successful web response" do
      expect { |probe| subject.find_existing(url_with_success_response, &probe) }.to yield_control
    end

    it "does not yield when there is not a successful web response" do
      expect { |probe| subject.find_existing(url_with_404_response, &probe) }.to_not yield_control
    end

    it "yields the checked URL" do
      subject.find_existing(url_with_success_response) do |url|
        expect(url).to eq 'HTTP://%s/' % url_with_success_response
      end
    end

    it "checks an array of URLs and executes the block for success responses" do
      successful_count = 0
      successful_url = nil

      subject.find_existing(various_urls) do |url|
        successful_count += 1
        successful_url = url
      end

      expect(successful_count).to eq 1
      expect(successful_url).to match url_with_success_response
    end
  end
end

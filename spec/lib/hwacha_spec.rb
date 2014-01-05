require_relative '../../lib/hwacha'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :typhoeus
end

describe Hwacha, "initialization" do
  it "defaults to 20 max concurrent requests" do
    expect(Hwacha.new.max_concurrent_requests).to eq 20
  end

  it "takes an integer argument to set the number of max concurrent requests" do
    expect(Hwacha.new(10).max_concurrent_requests).to eq 10
  end

  it "can set max_concurrent_requests via a configuration object" do
    hwacha = Hwacha.new do |config|
      config.max_concurrent_requests = 10
    end
    expect(hwacha.max_concurrent_requests).to eq 10
  end
end

describe Hwacha, "instance methods" do
  let(:url_with_success_response) { 'rakeroutes.com' }
  let(:url_with_404_response) { 'rakeroutes.com/this-url-does-not-exist' }
  let(:not_a_url) { '' }
  let(:various_urls) do
    [url_with_success_response, url_with_404_response, not_a_url]
  end

  describe "#check" do
    it "yields when there is a successful web response" do
      VCR.use_cassette('url_with_success_response') do
        expect { |probe| subject.check(url_with_success_response, &probe) }.to yield_control
      end
    end

    it "yields when there is not a successful web response" do
      VCR.use_cassette('url_with_404_response') do
        expect { |probe| subject.check(url_with_404_response, &probe) }.to yield_control
      end
    end

    it "yields when there is no web response" do
      VCR.use_cassette('not_a_url') do
        expect { |probe| subject.check(not_a_url, &probe) }.to yield_control
      end
    end

    it "yields the checked URL" do
      VCR.use_cassette('url_with_success_response') do
        subject.check(url_with_success_response) do |url, _|
          expect(url).to eq "HTTP://%s/" % url_with_success_response
        end
      end
    end

    it "yields the web response" do
      VCR.use_cassette('url_with_success_response') do
        subject.check(url_with_success_response) do |_, response|
          expect(response.success?).to be_true
        end
      end
    end

    it "checks an array of urls and executes the block for each" do
      VCR.use_cassette('various_urls') do
        urls_checked = 0

        subject.check(various_urls) do |url, response|
          urls_checked += 1
        end

        expect(urls_checked).to eq various_urls.size
      end
    end
  end

  describe "#find_existing" do
    it "yields when there is a successful web response" do
      VCR.use_cassette('url_with_success_response') do
        expect { |probe| subject.find_existing(url_with_success_response, &probe) }.to yield_control
      end
    end

    it "does not yield when there is not a successful web response" do
      VCR.use_cassette('url_with_404_response') do
        expect { |probe| subject.find_existing(url_with_404_response, &probe) }.to_not yield_control
      end
    end

    it "yields the checked URL" do
      VCR.use_cassette('url_with_success_response') do
        subject.find_existing(url_with_success_response) do |url|
          expect(url).to eq 'HTTP://%s/' % url_with_success_response
        end
      end
    end

    it "checks an array of URLs and executes the block for success responses" do
      VCR.use_cassette('various_urls') do
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
end

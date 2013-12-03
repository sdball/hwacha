require_relative '../../lib/hwacha'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :typhoeus
end

describe Hwacha do
  let(:page_with_success_response) { 'rakeroutes.com' }

  describe "#check" do
    it "yields when there is a successful web response" do
      VCR.use_cassette('page_with_success_response') do
        expect { |probe| subject.check(page_with_success_response, &probe) }.to yield_control
      end
    end

    it "yields the checked URL" do
      VCR.use_cassette('page_with_success_response') do
        subject.check(page_with_success_response) do |url, response|
          expect(url).to eq "HTTP://%s/" % page_with_success_response
        end
      end
    end

    it "yields the web response" do
      VCR.use_cassette('page_with_success_response') do
        subject.check(page_with_success_response) do |url, response|
          expect(response.success?).to be_true
        end
      end
    end
  end
end

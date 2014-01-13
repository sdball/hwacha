require_relative '../../lib/hwacha'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :typhoeus
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
end

success_url_vcr_options = { :cassette_name => 'success_url' }
not_found_url_vcr_options = { :cassette_name => '404_url' }

describe Hwacha do
  describe "checking a site that returns HTTP 200", :vcr => success_url_vcr_options do
    let(:url) { 'http://rakeroutes.com/' }

    it "visits the site and gets a valid response" do
      subject.check(url) do |url, response|
        expect(url.downcase).to eq url
        expect(response.code).to eq 200
        expect(response.body).to include 'Rake Routes'
      end
    end
  end

  describe "checking a site that returns HTTP 404", :vcr => not_found_url_vcr_options do
    let(:url) { 'http://rakeroutes.com/this-page-does-not-exist' }
    it "visits the site and records the 404 status" do
      subject.check(url) do |url, response|
        expect(url.downcase).to eq url
        expect(response.code).to eq 404
      end
    end
  end
end

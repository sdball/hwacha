require_relative '../../lib/hwacha'

describe Hwacha do
  let(:page_with_success_response) { 'rakeroutes.com' }

  describe "#check" do
    it "yields when there is a successful web response" do
      expect { |probe| subject.check(page_with_success_response, &probe) }.to yield_control
    end
  end
end

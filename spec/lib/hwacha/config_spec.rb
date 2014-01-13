require_relative '../../../lib/hwacha'

describe Hwacha::Config do
  describe "#options" do
    context "when no options are set" do
      it "is an empty hash" do
        expect(subject.options).to be == {}
      end
    end

    context "when max_concurrent_requests is set" do
      let(:max_concurrent_requests) { 50 }
      let(:concurrency_option) do
        { :max_concurrency => max_concurrent_requests }
      end

      before do
        subject.max_concurrent_requests = max_concurrent_requests
      end

      it "exports as max_concurrency in a hash" do
        expect(subject.options).to include concurrency_option
      end
    end
  end
end

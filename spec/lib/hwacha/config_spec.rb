require_relative '../../../lib/hwacha'

describe Hwacha::Config do
  describe "#hydra_options" do
    context "when no options are set" do
      it "is an empty hash" do
        expect(subject.hydra_options).to be == {}
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
        expect(subject.hydra_options).to include concurrency_option
      end
    end
  end

  describe "#request_options" do
    context "when follow_redirects option is set" do
      let(:follow_redirects) { true }
      let(:follow_redirects_option) do
        { :followlocation => follow_redirects }
      end

      before do
        subject.follow_redirects = follow_redirects
      end

      it "exports as followlocation in a hash" do
        expect(subject.request_options).to include follow_redirects_option
      end
    end
  end
end

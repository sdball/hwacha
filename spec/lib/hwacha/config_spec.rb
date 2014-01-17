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
    context "when follow_redirects option is true" do
      before do
        subject.follow_redirects = true
      end

      it "exports followlocation as true" do
        expect(subject.request_options.fetch(:followlocation)).to be_true
      end
    end

    context "when follow_redirects option is not set" do
      it "exports followlocation as false" do
        expect(subject.request_options.fetch(:followlocation)).to be_false
      end
    end

    context "when follow_redirects option is false" do
      it "exports followlocation as false" do
        expect(subject.request_options.fetch(:followlocation)).to be_false
      end
    end

    context "when ricochet is set" do
      it "treats ricochet as an alias for follow_redirects" do
        subject.ricochet = true
        expect(subject.request_options.fetch(:followlocation)).to be_true
      end

      it "has a lower precedence than setting follow_redirects" do
        subject.ricochet = true
        subject.follow_redirects = false
        expect(subject.request_options.fetch(:followlocation)).to be_false
      end
    end
  end
end

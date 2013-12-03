require "hwacha/version"
require "typhoeus"

class Hwacha
  def initialize(max_concurrent_requests=20)
    @max_concurrent_requests = max_concurrent_requests
  end

  def check(pages)
    hydra = Typhoeus::Hydra.new(:max_concurrency => @max_concurrent_requests)

    Array(pages).each do |page|
      request = Typhoeus::Request.new(page)
      request.on_complete do |response|
        yield response.effective_url
      end
      hydra.queue request
    end

    hydra.run
  end
end

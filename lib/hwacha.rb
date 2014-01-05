require "hwacha/version"
require "hwacha/config"
require "typhoeus"

class Hwacha
  attr_reader :max_concurrent_requests

  def initialize(max_concurrent_requests=20)
    config = Hwacha::Config.new

    # support the simple legacy API
    config.max_concurrent_requests = max_concurrent_requests

    # the nice configuration object API
    yield config if block_given?

    @max_concurrent_requests = config.max_concurrent_requests
  end

  def check(urls)
    hydra = Typhoeus::Hydra.new(:max_concurrency => @max_concurrent_requests)

    Array(urls).each do |url|
      request = Typhoeus::Request.new(url)
      request.on_complete do |response|
        yield response.effective_url, response
      end
      hydra.queue request
    end

    hydra.run
  end

  def find_existing(urls)
    check(urls) do |url, response|
      yield url if response.success?
    end
  end

  # Hwacha!!!
  alias :fire :check
  alias :strike_true :find_existing
end

require "hwacha/version"
require "hwacha/config"
require "typhoeus"

class Hwacha
  attr_reader :config

  def initialize(max_concurrent_requests=20)
    config = Hwacha::Config.new

    # support the simple legacy API
    config.max_concurrent_requests = max_concurrent_requests

    # the nice configuration object API
    yield config if block_given?

    @config = config
  end

  def check(urls)
    hydra = build_hydra

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

  def build_hydra
    Typhoeus::Hydra.new(config.options)
  end
end

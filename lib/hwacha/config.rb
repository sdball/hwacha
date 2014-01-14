require 'ostruct'

class Hwacha
  class Config < OpenStruct
    def hydra_options
      options = {}
      options.merge(concurrency_option)
    end

    def request_options
      options = {}
      options.merge(follow_redirects_option)
    end

    private

    def concurrency_option
      return {} if max_concurrent_requests.nil?
      { :max_concurrency => max_concurrent_requests }
    end

    def follow_redirects_option
      return { :followlocation => false } if follow_redirects.nil?
      { :followlocation => !!follow_redirects }
    end
  end
end

require 'ostruct'

class Hwacha
  class Config < OpenStruct
    def options
      options = {}
      options.merge(concurrency_option)
    end

    private

    def concurrency_option
      return {} if max_concurrent_requests.nil?
      { :max_concurrency => max_concurrent_requests }
    end
  end
end

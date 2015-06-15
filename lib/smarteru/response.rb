module Smarteru
  class Response
    attr_reader :data, :hash, :opts

    # Initializes an API response
    #
    # ==== Attributes
    # * +resp+ - RestClient response from the API
    def initialize(res, opts = {})
      @data = res
      opts[:parser] ||= XmlHasher::Parser.new(
        snakecase:         true,
        ignore_namespaces: true,
        string_keys:       false)
      @opts = opts
    end

    # Hash representation of response data
    def hash
      @hash ||= opts[:parser].parse(data.to_s.gsub(/\<!\[CDATA\[([^\]]+)\]\]\>/) {$1})
    end

    # Return true/false based on the API response status
    def success?
      hash[:smarter_u][:result] == 'Success'
    rescue
      false
    end

    def result
      hash[:smarter_u][:info]
    end

    def error
      errors = hash[:smarter_u][:errors]
      errors.is_a?(Hash) ? errors : nil
    end
  end
end

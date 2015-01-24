module Smarteru
  class Response
    attr_reader :data, :hash, :parser

    # Initializes an API response
    #
    # ==== Attributes
    # * +resp+ - RestClient response from the API
    def initialize(res)
      @data = res
      @parser = XmlHasher::Parser.new(
        snakecase: true,
        ignore_namespaces: true,
        string_keys: false
      )
    end

    # Hash representation of response data
    def to_hash
      return @hash if @hash
      @hash = parser.parse(data.to_s.gsub(/\<!\[CDATA\[(.+)\]\]\>/) {$1})
    end

    # Return true/false based on the API response status
    def success?
      to_hash[:smarter_u][:result] == 'Success'
    rescue
      false
    end

    def result
      to_hash[:smarter_u][:info]
    end

    def error
      to_hash[:smarter_u][:errors]
    end
  end
end

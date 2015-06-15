module Smarteru
  class Client
    attr_accessor :account_api_key, :user_api_key
    attr_reader :use_ssl, :verify_ssl,
                :ssl_ca_file, :api_url

    # Create an instance of an API client
    #
    # ==== Attributes
    # * +options+ - Access credentials and options hash, required keys are: account_api_key, user_api_key
    # ==== Example
    # client = Smarteru::Client.new({account_api_key: 'abc', user_api_key: 'abc'})
    def initialize(options = {})
      @account_api_key = options[:account_api_key] || ENV['SMARTERU_ACCOUNT_API_KEY']
      @user_api_key = options[:user_api_key] || ENV['SMARTERU_USER_API_KEY']
      @use_ssl = options[:use_ssl] || true
      @verify_ssl = options[:verify_ssl]
      @ssl_ca_file = options[:ssl_ca_file]
      @api_url = (@use_ssl ? 'https' : 'http') + "://#{API_HOST}/#{API_VERSION}/"
    end

    # Make an API request
    #
    # ==== Attributes
    # * +operation+  - Operation method eg getGroup
    # * +data+ - Data hash
    # ==== Example
    # client.request("getGroup", {
    #   group: {
    #     name: 'MyGroup'
    #   }
    # })
    def request(operation, data)
      opts = {
        method:       :post,
        url:          api_url,
        payload:      { 'Package' => body(operation, data) },
        content_type: :xml,
        verify_ssl:   verify_ssl,
        ssl_ca_file:  ssl_ca_file }
      response = RestClient::Request.execute(opts)

      Response.new(response)
    end

    def users
      @users ||= Resources::Users.new(self)
    end

    private

    # Build xml request body
    #
    # ==== Attributes
    # * +operation+ - Operation method
    # * +parameters+ - Parameters hash
    # ==== Example
    # client.body("createUser", {email: 'email@example.com', ...})
    def body(operation, param_data)
      %{<?xml version="1.0" encoding="UTF-8"?>
        <SmarterU>
        <AccountAPI>#{account_api_key}</AccountAPI>
        <UserAPI>#{user_api_key}</UserAPI>
        <Method>#{operation}</Method>
        <Parameters>#{body_parameters(param_data)}</Parameters>
        </SmarterU>}
    end

    # Build body parameteres xml
    #
    # ==== Attributes
    # * +parameters+ - Parameters hash
    def body_parameters(parameters)
      parameters_xml = ''
      parameters.each_pair do |k, v|
        key = parameter_key(k)

        val = case v
        when Hash
          body_parameters(v)
        when Array
          v.map { |i| body_parameters(i) }.join('')
        when nil
          ''
        else
          "<![CDATA[#{v}]]>"
        end

        parameters_xml << "<#{key}>#{val}</#{key}>"
      end

      parameters_xml
    end

    # Prepare parameter key
    #
    # ==== Attributes
    # * +parameters+ - Parameters hash
    def parameter_key(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string
    end
  end
end

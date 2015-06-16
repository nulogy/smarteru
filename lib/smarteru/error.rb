module Smarteru
  class Error < StandardError
    attr_reader :response, :code

    def initialize(response)
      @response = response
      @code = response.error[:error][:error_id]
      super(response.error[:error][:error_message])
    end

  end
end
require 'test/unit'
require 'webmock/test_unit'

require 'smarteru'

class Test::Unit::TestCase
  ACCESS_CREDENTIALS = {
    account_api_key: "abc",
    user_api_key: "abc"
  }

  def stub_v2_api_call(operation, payload_package_xml)
    filename = "#{operation}.xml"
    stub_request(:post, 'https://api.smarteru.com/apiv2/')
    .with(:body => {"Package"=>"#{payload_package_xml}"})
    .to_return(
      body: expected_body(filename),
      status: 200
    )
  end

  def request_payload(filename)
    File.read(File.join(File.dirname(__FILE__), 'support/requests/' << filename))
  end

  def expected_body(filename)
    File.read(File.join(File.dirname(__FILE__), 'support/responses/' << filename))
  end
end

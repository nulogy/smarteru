require 'helper'

class TestSmarteru < Test::Unit::TestCase

  def setup
    @client = Smarteru::Client.new(ACCESS_CREDENTIALS)
  end

  def test_request_get_group
    stub_request = stub_v2_api_call('getGroup', request_payload('getGroup.xml'))
    response = @client.request('getGroup', {group: {name: 'MyGroup'}})
    assert_equal(response.data, expected_body('getGroup.xml'))
    assert_requested(stub_request)
  end

  def test_response_result_hash
    stub_request = stub_v2_api_call('getGroup', request_payload('getGroup.xml'))
    response = @client.request('getGroup', {group: {name: 'MyGroup'}})
    assert_equal(response.result, {
      group: {
        name: "MyGroup",
        group_id: nil,
        created_date: "2015-01-22 23:42:55.553",
        modified_date: "2015-01-23 01:25:02.013",
        description: {
          p: "Group Description ..."
        },
        home_group_message: {
          p: "Welcome to The Group"
        },
        notification_emails: nil,
        user_count: "2",
        learning_module_count: "2",
        tags: nil,
        status: "Active"
      }
    })
  end

  def test_response_success_method
    stub_request = stub_v2_api_call('getGroup', request_payload('getGroup.xml'))
    response = @client.request('getGroup', {group: {name: 'MyGroup'}})
    assert_equal(true, response.success?)
  end
end

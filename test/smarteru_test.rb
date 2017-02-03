require 'test_helper'

class TestSmarteru < Test::Unit::TestCase
  def setup
    @client = Smarteru::Client.new(
      account_api_key: 'C3FE6BE08120A82DB9C4555A5C0E46AF',
      user_api_key:    '*623jec3nad4!aic5rlg*$mrg8n4$itd^vy62xut')
    # replace values w/ actual keys to run/test vcr cassettes
    # @client = Smarteru::Client.new(
    #   account_api_key: 'foo',
    #   user_api_key:    'bar')
  end

  GROUP_PARAMS = { group: { name: 'PowurU' } }
  def test_invalid_api_keys
    @client.account_api_key = 'foo'
    @client.user_api_key = 'bar'

    VCR.use_cassette('invalid_api_keys') do
      assert_raise_kind_of(Smarteru::Error) do
        @client.request('getGroup', GROUP_PARAMS)
      end
    end
  end

  def test_get_group
    with_request('get_group', 'getGroup', GROUP_PARAMS) do |response|
      assert_true response.success?
      assert_not_nil response.result[:group]
    end
  end

  def test_get_user
    email = 'vduplessie@gmail.com'

    VCR.use_cassette('get_user') do
      response = @client.users.get(email)
      assert_not_nil response[:email] == email
      assert_not_nil response[:status] == 'Active'
    end
  end

  def test_get_nonexistant_user
    VCR.use_cassette('get_nonexistant_user') do
      response = @client.users.get('noop@eyecuelab.com')
      assert_nil response
    end
  end

  def test_update_user
    VCR.use_cassette('update_user') do
      employee_id = 'powur.com:4242'
      response = @client.users.update('vduplessie@gmail.com', employee_i_d: employee_id)
      assert_true response.success?
      assert_true response.result.keys.include?(:employee_id)
      assert_equal response.result[:employee_id], employee_id
    end
  end

  def test_update_employee_id
    VCR.use_cassette('update_employee_id') do
      employee_id = 'powur.com:4242'
      response = @client.users.update_employee_id('vduplessie@gmail.com', employee_id)
      assert_true response.success?
      assert_true response.result.keys.include?(:employee_id)
      assert_equal response.result[:employee_id], employee_id
    end
  end

  def test_create_user
    employee_id = 'test.eyecuelab.com:42'
    params = {
      email:        'foo@eyecuelab.com',
      employee_i_d: employee_id,
      given_name:   'Test',
      surname:      'User',
      password:     'password',
      group:        'PowurU' }

    VCR.use_cassette('create_user') do
      response = @client.users.create(params)
      assert_true response.success?
      assert_true response.result.keys.include?(:employee_id)
      assert_equal response.result[:employee_id], employee_id
    end
  end

  def test_signin_user
    VCR.use_cassette('signin_user') do
      response = @client.users.signin('5258029611')
      assert_true response.success?
      assert_true response.result.keys.include?(:redirect_path)
    end
  end

  def test_enroll_user
    VCR.use_cassette('enroll_user') do
      response = @client.users.enroll('5258029611', 'PowurU', '8319')
      assert_true response.success?
      assert_true response.result.keys.include?(:enrollments)
    end
  end

  def test_learner_report
    VCR.use_cassette('learner_report') do
      response = @client.users.learner_report('5258029611', 'PowurU')
      assert_kind_of Array, response
    end
  end

  def test_enrolled_true
    VCR.use_cassette('enrolled_true') do
      response = @client.users.enrolled?('foo@eyecuelab.com', 'PowurU', 'Fast Impact Training (FIT)')
      assert_true response
    end
  end

  def test_enrolled_false
    VCR.use_cassette('enrolled_false') do
      response = @client.users.enrolled?('foo@eyecuelab.com', 'PowurU', 'Cert Pro')
      assert_false response
    end
  end

  private

  def with_request(cassette, method, params)
    VCR.use_cassette(cassette) do
      response = @client.request(method, params)
      yield(response) if block_given?
    end
  end
end

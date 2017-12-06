require 'helper'
require 'aws_iam_policy'

class AwsIamPolicyTest < Minitest::Test
	Arn = 'testarn'.freeze
	Policy = 'policytest'.freeze

	def setup
		@mock_conn = Minitest::Mock.new
		@mock_resource = Minitest::Mock.new
		@mock_policy = Minitest::Mock.new
		@mock_conn.expect :iam_resource, @mock_resource
		@mock_resource.expect :policy, @mock_policy, [Arn]
	end
	
	def test_policy_exists_when_policy_exists
		@mock_policy.expect :nil?, false
		assert AwsIamPolicy.new(Arn,@mock_conn).exists?
	end

	def test_policy_does_not_exist_when_no_policy_exists
		@mock_policy.expect :nil?, true
		refute AwsIamPolicy.new(Arn,@mock_conn).exists?
	end

	def test_name_returns_policy_name
		@mock_policy.expect :nil?, false
		@mock_policy.expect :policy_name, Policy
		assert_equal Policy, AwsIamPolicy.new(Arn,@mock_conn).name
	end

	def test_name_returns_false_when_policy_name_does_not_match
		@mock_policy.expect :nil?, false
		@mock_policy.expect :policy_name, Arn
		refute_equal Policy, AwsIamPolicy.new(Arn,@mock_conn).name
	end

	def test_name_returns_exception_when_policy_does_not_exist
		@mock_policy.expect :nil?, true
		@mock_policy.expect :policy_name, Policy
		e = assert_raises Exception do 
			AwsIamPolicy.new(Arn,@mock_conn).name
		end
		assert_equal e.message, 'this policy does not exist'
	end

	def test_attachment_count_returns_count
		@mock_policy.expect :nil?, false
		@mock_policy.expect :attachment_count, 1
		refute_nil AwsIamPolicy.new(Arn,@mock_conn).attachment_count
	end

	def test_attachment_count_when_there_are_no_attachment_count
		@mock_policy.expect :nil?, false
		@mock_policy.expect :attachment_count, nil 
		assert_nil AwsIamPolicy.new(Arn,@mock_conn).attachment_count
	end

	def test_attachment_count_returns_exception_when_policy_does_not_exist
		@mock_policy.expect :nil?, true
		@mock_policy.expect :attachment_count, 1
		e = assert_raises Exception do 
			AwsIamPolicy.new(Arn,@mock_conn).attachment_count
		end
		assert_equal e.message, 'this policy does not exist'
	end

end
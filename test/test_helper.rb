ENV["RAILS_ENV"] ||= "test"
ENV["OPENAI_BASE_URL"] ||= "https://openai.local/api"
ENV["OPENAI_API_KEY"] ||= "test_api_key"

require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helper/session_test_helper"
require "webmock/minitest"

module ActiveSupport
  class TestCase
    include SessionTestHelper
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

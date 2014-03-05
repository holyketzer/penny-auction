require 'spec_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  OmniAuth.config.test_mode = true
  WebMock.disable_net_connect!(:allow_localhost => true)

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include Features::SessionsHelpers, type: :feature
  config.include Features::CapybaraHelper
  config.include ApplicationHelper  

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
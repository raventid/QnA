require 'rails_helper'

RSpec.configure do |config| 
  # Assign webkit driver to capybara to improve speed
  Capybara.javascript_driver = :webkit  

  # Add acceptance_helper macros
  config.include AcceptanceHelpers, type: :feature
  # Add sphinx test helpers
  config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  #Configuration for database_cleaner
  #Before all specs this is running
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)

    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init

    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  #we don't save data in database
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    # Sphinx Index data when running an acceptance spec.
    DatabaseCleaner.strategy = :truncation
    index
  end

  #for each spec which is js: true we use :trancation to save real data in database
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

OmniAuth.config.test_mode = true
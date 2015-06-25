require 'rails_helper'

RSpec.configure do |config| 
  #Assign webkit driver to capybara to improve speed	
  Capybara.javascript_driver = :webkit  

  #Add acceptance_helper macros
  config.include AcceptanceHelpers, type: :feature

  config.use_transactional_fixtures = false

  #Configuration for database_cleaner
  #Before all specs this is running
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  #we don't save data in database
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
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
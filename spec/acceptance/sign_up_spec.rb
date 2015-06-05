require 'rails_helper'

feature 'Sign up', %q{
  User can register on site
  In order to create questions and answers
} do
  
  scenario 'Non-registered user try to sign up' do

    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.test'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'

  end


end
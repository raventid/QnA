require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  feature 'User can sign in via oauth' do
    scenario "facebook" do
      visit root_path
      click_on "Sign in"
      #binding.pry
      click_on "Sign in with Facebook"
      mock_auth_hash_facebook
      expect(page).to have_content "Successfully authenticated from Facebook account."
    end
  end
end
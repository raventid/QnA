require_relative 'acceptance_helper'

feature 'User sign in with Facebook', %q{
  In order to easily sign in
  As an user
  I want to be able to sign in with Facebook
} do

  given(:registered_user) { create(:user) }
  given(:unregistered_user) { build(:user) }

  background { visit new_user_session_path }

  scenario 'A registered user signs in with Facebook' do
    auth_with :facebook, registered_user.email
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to_not have_content 'Login'
    expect(page).to have_content 'Logout'
  end

  scenario 'An unregistered user signs in with Facebook' do
    auth_with :facebook, unregistered_user.email
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to_not have_content 'Login'
    expect(page).to have_content 'Logout'
  end
end
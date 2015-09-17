require_relative 'acceptance_helper'

feature 'User sign in with Twitter', %q{
  In order to easily sign in
  As an user
  I want to be able to sign in with Twitter
} do

  given(:unregistered_user) { build(:user) }
  given(:unconfirmed_verification) { create(:verification, provider: 'twitter') }
  given(:registered_user) { create(:user) }
  given(:twitter_authorization) { create(:twitter_authorization, user: registered_user) }

  background(:each) do |scenario|
    visit new_user_session_path
    twitter_authorization if scenario.metadata[:register_authorization]
    auth_with :twitter
    click_on 'Sign in with Twitter'
  end

  describe 'An unregistered user signs in with Twitter' do
    scenario 'sees email verification field' do
      expect(current_path).to eq new_verification_path
      expect(page).to have_field 'Email'
    end

    scenario 'fills in email' do
      fill_in 'Email', with: unregistered_user.email
      click_on 'Submit'

      expect(page).to have_content 'Successfully authenticated from Twitter account'
    end
  end

  describe 'User signs in with Twitter and specify wrong data' do
    scenario 'empty email' do
      click_on 'Submit'

      expect(page).to have_content "can't be blank"
    end

    scenario 'invalid email' do
      fill_in 'Email', with: 'test1'
      click_on 'Submit'

      expect(page).to have_content 'is invalid'
    end

    scenario 'already specified this email but does not confirm it' do
      fill_in 'Email', with: unconfirmed_verification.email
      click_on 'Submit'

      expect(page).to have_content "We've already sent you mail. Please check your inbox."
    end
  end

  scenario 'A registered user with confirmed Twitter account', register_authorization: true do
    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end

  scenario 'A registered user without a sign in with Twitter' do
    fill_in 'Email', with: registered_user.email
    click_on 'Submit'

    expect(page).to have_content " We've sent confirmation email. Please check your inbox for further instructions."

    open_email(registered_user.email)
    current_email.click_link 'this link'

    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end
end
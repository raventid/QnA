require 'rails_helper'

feature 'Loged in user is able to log out' do

  given(:user) { create(:user) }

  scenario 'User try to log out' do
  	sign_in(user)

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end
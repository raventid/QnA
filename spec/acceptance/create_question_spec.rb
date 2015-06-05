require 'rails_helper'

feature 'Create question', %q{
	To get an answer
	As an authencticated user
	I want to be able to ask questions
} do 
  
  given(:user) { create(:user) }

  scenario 'Authencticated user creates question' do
    sign_in(user)
    
    q = {title: 'Test question', text: 'text text'}

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: q[:title] 
    fill_in 'Body', with: q[:text]
    click_on 'Create'

    expect(page).to have_content q[:title]
    expect(page).to have_content q[:text]
    expect(page).to have_content "Know answer? Write here"
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
	
end
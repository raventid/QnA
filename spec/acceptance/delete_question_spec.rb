require 'rails_helper'

feature 'Athenticated user can delete questions' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'User tries to delete his own question' do
    sign_in(user)

    visit question_path(question)

    click_on 'delete'

    expect(page).to have_content 'Your Question successfully deleted.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'User tries to delete question which belongs to another user' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_link 'delete'
  end

  scenario 'Non-authencticated user tries to delete question' do
    
    visit question_path(question)

    expect(page).to_not have_link 'delete'
    
  end

end

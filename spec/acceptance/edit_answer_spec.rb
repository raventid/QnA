require_relative 'acceptance_helper'

feature 'Answer editing', %q{
	In order to fix mistake
	As an author of Answer
	I'd like to be able to edit my answer
} do

given(:user) { create(:user) }
given!(:question) { create(:question) }
given!(:answer) { create(:answer, question: question, user: user) }

scenario 'Unauthenticated user try to edit question' do
  visit question_path(question)

  expect(page).to_not have_link 'Edit'
end

describe 'Authenticated user' do 
  before do
    sign_in user
    visit question_path(question)
  end

  scenario 'sees link to edit answer' do
    within '.answers' do  
      expect(page).to have_link 'Edit'
    end
  end

  scenario 'tries to edit his answer' do
    click_on 'Edit'
    within '.answers' do
      fill_in 'Answer', with: 'edited answer'
    end
    click_on 'Save'

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'edited answer'
    expect(page).to_not have_selector 'textarea'
  end

  scenario 'user see edit link if he is the author'
  scenario 'tries to edit other users answer'
end
end

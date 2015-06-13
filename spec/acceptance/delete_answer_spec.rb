require 'rails_helper'

feature 'Authenticated user deletes answer', %q{
  User can delete his own answers
} do

  #Вопрос больше не должен отображаться на страничке
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user is able to delete his own answer' do
    sign_in(user)

    visit question_path(question)

    click_on 'Delete my answer'

    expect(page).to have_content 'Your answer has been deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete an answer of another user' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario "Non-authenticated user can not delete answer" do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end
end

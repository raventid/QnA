require_relative 'acceptance_helper'

feature 'Delete attached files', %q{
  In order to clear my answer or question 
  As an author of answer or question
  I'd like to be able to remove files
} do

  given(:owner){ create(:user)}
  given(:user){ create(:user)}
  given(:question){create(:question, user: owner) }
  given(:answer){create(:answer, user: owner, question: question) }
  given!(:a_attach){create(:answer_attachment, attachable: answer) }
  given!(:q_attach){create(:question_attachment, attachable: question) }

  scenario 'Owner can to delete a file attached to the question', js: true do
    sign_in(owner)
    visit question_path(question)
    within '.question-block' do
      expect(page).to have_content q_attach.file.filename
      click_on 'Delete file'

      expect(page).to_not have_content q_attach.file.filename
    end
  end

  scenario 'User can\'t to delete a file attached to the question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question-block' do
      expect(page).to_not have_content 'Delete file'
    end
  end

  scenario 'Owner can to delete a file attached to the answer', js: true do
    sign_in(owner)
    visit question_path(question)
    within "#answer-block-#{answer.id}" do
      expect(page).to have_content a_attach.file.filename
      click_on 'Delete file'

      expect(page).to_not have_content a_attach.file.filename
    end
  end

  scenario 'User can\'t to delete a file attached to the answer', js: true do
    sign_in(user)
    visit question_path(question)
    within "#answer-block-#{answer.id}" do
      expect(page).to_not have_content 'Delete file'
    end
  end
end 

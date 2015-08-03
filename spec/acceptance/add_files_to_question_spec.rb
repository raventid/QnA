require_relative 'acceptance_helper'

feature 'Add files', %q{
  In order to illustrate my question
  As a question's author
  I would like to be able to attach file to my question
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  # We don't need js: true here cause we add just one file to new Question
  #scenario 'User adds file when asks question'do
  #  fill_in 'Title', with: 'New question title'
  #  fill_in 'Body', with: 'New question body'
  #  attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

  #  click_on 'Create'


  #  expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

  #end

  
  scenario 'User adds some files when ask question', js: true do
    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'

    click_on 'Add file'
    within ('.question-attachments .nested-fields:first-child') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add file'
    within ('.question-attachments .nested-fields:nth-child(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'

    sleep(1)
  
    question = Question.first
    attaches = []
    question.attachments.each {|a| attaches << a }
  
    expect(page).to have_link attaches[0].file.filename, href: attaches[0].file.url
    expect(page).to have_link attaches[1].file.filename, href: attaches[1].file.url
  end
end

feature 'Add files to question' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when edit question', js: true do
    within '#question-block' do
      click_on 'Edit'
      click_on 'Add file'
      within '.question-attachments .nested-fields:first-child' do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'Save'
    end

    sleep(1)

    attach = Question.first.attachments.first
    expect(page).to have_link attach.file.filename, href: attach.file.url
  end
end 

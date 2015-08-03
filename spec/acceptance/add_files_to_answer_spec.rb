require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do
  
  given(:user){ create(:user) }
  given(:question){ create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  #scenario 'User adds one file when asks question', js: true do
  #  fill_in 'Know answer? Write here', with: 'My answer'
  #  attach_file 'File', "#{Rails.root}/spec/spec_helper.rb" 
  #  click_on 'Add'
  #  within '.answers' do
  #    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  #  end
  #end

  scenario 'User adds some files when create answer', js: true do
    fill_in 'Know answer? Write here', with: 'Body answer text'

    within '#create-new-answer' do
      click_on 'Add file'
      within '.answer-attachments .nested-fields:first-child' do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Add file'
      within '.answer-attachments .nested-fields:nth-child(2)' do
        attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Add'
    end
    sleep(1)
    answer = question.answers.first
    attaches = []
    answer.attachments.each { |a| attaches << a }

    within '.answers' do
      expect(page).to have_link attaches[0].file.filename, href: attaches[0].file.url
      expect(page).to have_link attaches[1].file.filename, href: attaches[1].file.url
    end
  end
end

feature 'Add files to answer while editing', %q{
    As an author of answer 
    I would like to add some files to my answer
    While I'm editing this answer
} do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when edit answer', js: true do
    within "#answer-block-#{answer.id}" do
      click_on 'Edit'

      click_on 'Add file'
      within '.answer-attachments .nested-fields:first-child' do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Add file'
      within '.answer-attachments .nested-fields:nth-child(2)' do
        attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Save'
    end

    sleep(1)
    answer = question.answers.first
    attaches = []
    answer.attachments.each { |a| attaches << a }

    within "#answer-block-#{answer.id}" do
      expect(page).to have_link attaches[0].file.filename, href: attaches[0].file.url
      expect(page).to have_link attaches[1].file.filename, href: attaches[1].file.url
    end

  end
end 


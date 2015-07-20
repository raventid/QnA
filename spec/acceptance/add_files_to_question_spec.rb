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

  scenario 'User adds file when asks question'do
    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'


    expect(page).to have_content 'spec_helper.rb'

  end
end

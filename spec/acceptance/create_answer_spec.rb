require_relative 'acceptance_helper'

feature 'Authenticated user creates answer', %q{
         To help other users
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Know answer? Write here', with: 'My answer'
    click_on 'Add'

    expect(current_path).to eq question_path(question)
    #expect(page).to have_content 'Your answer has been added! Thank you!'
    #expect(page).to have_content 'My answer'
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authenticated user tries to create an answer' do

    visit question_path(question)

    expect(page).to have_content 'To answer the question you need to be signed in.'
    expect(page).to_not have_css ('form')
  end

  scenario 'User tries to create invalid answer', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Add'

    expect(page).to have_content "Body can't be blank"
  end
end

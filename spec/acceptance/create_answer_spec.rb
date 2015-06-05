require 'rails_helper'

feature 'Authenticated user creates answer', %q{
         To help other users
} do

  #На странице должно быть тело ответа
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create an answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Know answer? Write here', with: 'My answer'
    click_on 'Add'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer has been added! Thank you!'
    expect(page).to have_content 'My answer'
  end

  scenario 'Non-authenticated user tries to create an answer' do

    visit question_path(question)

    expect(page).to have_content 'To answer the question you need to be signed in.'
    #expect(page).to_not have_content ('Save answer')
    expect(page).to_not have_css ('form')
  end
end

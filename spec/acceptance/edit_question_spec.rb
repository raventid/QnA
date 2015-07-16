require_relative 'acceptance_helper'

feature 'Question editing', %q{
   In order to fix mistake
   Authenticated user tries to edit question
} do

  given(:user_ivan){ create(:user) }
  given(:ivans_question){ create(:question, user: user_ivan) }
  given(:question){ create(:question) }


  scenario "Authenticated user try to edit other user's question" do
    sign_in(user_ivan)
    visit question_path(question)
  
    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end

require 'acceptance/acceptance_helper.rb'

  feature 'Add comment to question' do

    given(:user) {create(:user)}
    given!(:question) {create(:question)}

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User can add comment to question", js: true do
      within "#question-block" do
      click_on "Add comment"
      fill_in "Comment", with: "I wrote this super comment for this question"
      click_on 'Create'
      expect(page).to have_content "I wrote this super comment for this question"
      expect(page).to have_link "Add comment"
      end
    end

  end
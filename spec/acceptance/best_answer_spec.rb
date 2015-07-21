require_relative 'acceptance_helper'

feature 'Best answer', %q{
  In order to mark best solution
  As an author of question
  User should be able to select best answer
} do

  given(:topic_starter) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: topic_starter) }
  given!(:good_answer) { create(:answer, question: question, user: user) }
  given!(:another_good_answer) { create(:answer, user: user) }


  describe 'Author views answers' do
    scenario 'Author sees link to choose best answer' do
      sign_in(topic_starter)

      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'best' 
      end 
    end
    
    scenario 'Author select best answer', js: true do

      sign_in(topic_starter)

      visit question_path(question)

      within '.answers' do
        click_on 'best'
      end
      within '.answers' do
        expect(page).to have_selector '.best-answer'
        expect(page).to_not have_content 'best'
      end
      within '.best-answer' do
        expect(page).to have_content good_answer.body
      end
    end

    scenario 'Author select another answer as best', js: true do
      sign_in(topic_starter)

      visit question_path(question)

      within '.answers' do
        click_on 'best'
      end
      
      another_good_answer.update!(question: question, body: 'Absolutly another text no one expect to see here')
      visit question_path(question)

      within '.answers' do
        click_on 'best' 
      end

      within '.answers' do
        expect(page).to have_selector '.best-answer' 
      end

      within '.best-answer' do
        expect(page).to have_content another_good_answer.body
	expect(page).to_not have_content good_answer.body
      end
    end
  end
end 


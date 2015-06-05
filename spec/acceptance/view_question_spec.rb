require 'rails_helper'

feature 'All users can view the questions', %q{
         In order to find interesting ones
} do

  given(:question) { create(:question) }

  scenario 'All users and guests are able to view all the questions' do

    questions = create_list(:rand_title_question, 2)

    visit questions_path

    questions.each do |q|
      expect(page).to have_link q.title
    end
  end

  scenario 'All users and guests are able to view question and answers for this question' do
   
    question.answers = create_list(:rand_body_answer, 2)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |a|
      expect(page).to have_content a.body
    end

  end

end

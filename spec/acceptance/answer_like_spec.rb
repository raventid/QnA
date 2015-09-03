require_relative 'acceptance_helper'
 
 feature 'Answer like or dislike', %q{
   In order to vote for good or bad answer
   As user
   I want to be able to like or dislike answer
 } do
 
   given!(:users) { create_list(:user, 2) }
   given!(:question) { create(:question) }
   given!(:answer) { create(:answer, question: question, user: users[0]) }
 
   scenario "User try like or dislike his answer" do
 
     sign_in(users[0])
     visit question_path(question)

     within ".vote-answer-#{answer.id}" do
       expect(page).to_not have_link 'like'
       expect(page).to_not have_link 'dislike'
     end
   end
 
   scenario "User try to like other's answer", js: true do
 
     sign_in(users[1])
     visit question_path(question)

     within ".vote-answer-#{answer.id}" do
       save_and_open_screenshot
       click_on 'like'
       expect(page).to have_content '1'
     end
   end
 
   scenario "User try to dislike other's answer", js: true do
     sign_in(users[1])
     visit question_path(question)

     within ".vote-answer-#{answer.id}" do
       click_on 'dislike'
       expect(page).to have_content '-1'
     end
   end
 
   scenario "Non-authenticated user try to like or dislike answer" do
 
     visit question_path(question)

     within ".vote-answer-#{answer.id}" do
       expect(page).to_not have_link 'like'
       expect(page).to_not have_link 'dislike'
     end
   end
 
   before { answer.votes.create(user: users[1]) }
 
   scenario "User try to cancel his vote", js: true do
 
     sign_in(users[1])
 
     visit question_path(question)

     within ".vote-answer-#{answer.id}" do
       click_on 'cancel'
       expect(page).to have_content '0'
     end
   end
 end

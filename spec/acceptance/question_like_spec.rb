require_relative 'acceptance_helper'
 
 feature 'Question like or dislike', %q{
   In order to vote for good or bad question
   As user
   I want to be able to like or dislike question
 } do
 
   given(:users){ create_list(:user, 2) }
   given(:question){ create(:question, user: users[0]) }
 
   scenario "User try to like or dislike his question", js: true do
 
     sign_in(users[0])
     visit question_path(question)

     within '#question-block' do
       within  '.rating' do
         expect(page).to_not have_link 'like'
         expect(page).to_not have_link 'dislike'
       end
     end
   end
 
   scenario "User try to like other's question", js: true do
     
     sign_in(users[1])
     visit question_path(question)
 
     within '#question-block' do
       within  '.rating' do
         click_on 'like'
         expect(page).to have_content '1'
       end
     end
   end
 
   scenario "User try to dislike other's question", js: true do
 
     sign_in(users[1])
     visit question_path(question)
 
     within '#question-block' do
       within  '.rating' do
        click_on 'dislike'
        expect(page).to have_content '-1'
       end
     end
   end
 
   scenario "Non-authenticated user try to like or dislike some question", js: true do

     visit question_path(question)

     within '#question-block' do
       within  '.rating' do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
       end
     end
   end
 
 
   before { question.votes.create(user: users[1], like: 1) }
 
   scenario "User try to cancel his vote", js: true do
 
     sign_in(users[1])
 
     visit question_path(question)
 
     within '#question-block' do
       within  '.rating' do
        click_on 'cancel'
        expect(page).to have_content '0'
       end
     end

   end

end
require_relative 'acceptance_helper'

feature 'User can search', %q{
    In order to find content
    As a visitor of the site
    I should be able to search information
  } do

  given!(:users) { create_pair :user }
  given!(:questions) { create_pair :question }
  given!(:answers) { create_pair :answer }
  given!(:question) { create :question, body: 'gotcha! question' }
  given!(:answer) { create :answer, body: 'gotcha! answer' }
  given!(:comment) do
    create :comment, comment_body: 'gotcha! comment', commentable: question, commentable_type: 'Question'
  end
  given!(:user) { create :user, email: 'gotcha!@example.com' }

  scenario 'User searches all', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'gotcha!'
      select 'None', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.comment_body
        expect(page).to have_content user.email
      end
    end
  end

  scenario 'User searches question', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'gotcha!'
      select 'Question', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.comment_body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches answer', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'gotcha!'
      select 'Answer', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to have_content answer.body
        expect(page).to_not have_content comment.comment_body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches comment', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'gotcha!'
      select 'Comment', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to have_content comment.comment_body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches user', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'gotcha!'
      select 'User', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.comment_body
        expect(page).to have_content user.email
      end
    end
  end
end
require 'rails_helper'

feature 'User can comment for answer', %q{
  In order to comment to a community
  As an authenticated user
  I'd like to give my comment for an answer
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Not authenticated user' do
    scenario 'Can not comment' do
      visit question_path(question)

      expect(page).to_not have_selector '.new-comment'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can sent comment' do
      within "#answer_#{answer.id}" do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'tries sent comment with errors' do
      within "#answer_#{answer.id}" do
        click_on 'Add comment'

        expect(page).to have_content "body can't be blank"
      end
    end
  end

  describe 'Multiple sessions', js: true do
    scenario 'comments appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer_#{answer.id}" do
          fill_in 'Comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within "#answer_#{answer.id}" do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end

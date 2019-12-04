require 'rails_helper'

feature 'User can receive email notifications about new answers', %q{
    In order to have information about new answers
    As an authenticated user
    I would like to able to receive email notifications
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Email notifications', js: true do

    before { Sidekiq::Testing.inline! }

    context 'Author' do
      scenario 'get notifications about new answers' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within '.new-answer' do
            fill_in 'Body', with: 'New answer'
            click_on 'Create'
          end

          expect(page).to have_content 'New answer'
        end

        Capybara.using_session('author') do
          open_email(author.email)
          expect(current_email).to have_content 'New answer for question'
        end
      end

    scenario 'does not get notifications about new answers if unsubscribed' do
        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)
          click_on 'Unsubscribe'
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within '.new-answer' do
            fill_in 'Body', with: 'New answer'
            click_on 'Create'
          end

          expect(page).to have_content 'New answer'
        end

        Capybara.using_session('author') do
          open_email(author.email)
          expect(current_email).to_not have_content 'New answer for question'
        end
      end
    end

      context 'User' do
        scenario 'get notifications about new answers to subscribed question' do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
            click_on 'Subscribe'
          end

          Capybara.using_session('author') do
            sign_in(user)
            visit question_path(question)

            within '.new-answer' do
              fill_in 'Body', with: 'New answer'
              click_on 'Create'
            end

            expect(page).to have_content 'New answer'
          end

          Capybara.using_session('user') do
            open_email(user.email)
            expect(current_email).to have_content 'New answer for question'
          end
        end

        scenario 'does not get notifications about new answers to unsubscribed question' do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
            click_on 'Subscribe'
            click_on 'Unsubscribe'
          end

          Capybara.using_session('author') do
            sign_in(user)
            visit question_path(question)

            within '.new-answer' do
              fill_in 'Body', with: 'New answer'
              click_on 'Create'
            end

            expect(page).to have_content 'New answer'
          end

          Capybara.using_session('user') do
            open_email(user.email)
            expect(current_email).to_not have_content 'New answer for question'
          end
        end
      end

    after { Sidekiq::Testing.disable! }
  end
end

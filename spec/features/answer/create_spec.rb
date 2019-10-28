require 'rails_helper'

feature 'User can create answers for questions', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
}, :vcr do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'http://glebkaif.ru' }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create the answer with valid data' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Create'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer text'
      end
    end

    scenario 'create the answer with empty data' do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached files' do
      fill_in 'Body', with: 'Answer text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Multiple sessions', js: true do
    scenario 'answer appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'My answer'

        fill_in 'Link name', with: 'SomeLink'
        fill_in 'Url', with: url

        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'My answer'
          expect(page).to have_link 'SomeLink', href: url
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'My answer'
          expect(page).to have_link 'SomeLink', href: url
        end
      end
    end
  end

  scenario 'Non authenticated user can not create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end
end

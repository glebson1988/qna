require 'rails_helper'

feature 'User can create answers for questions', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

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

  scenario 'Non authenticated user can not create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end
end

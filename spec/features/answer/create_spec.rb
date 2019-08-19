require 'rails_helper'

feature 'User can create answers for questions', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create the answer with valid data' do
      fill_in 'Body', with: 'Answer text'
      click_on 'New answer'
      expect(page).to have_content 'Answer text'
    end

    scenario 'create the answer with empty data' do
      click_on 'New answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non authenticated user can not create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'New answer'
  end
end

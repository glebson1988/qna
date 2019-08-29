require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete non-actual answer
  As an user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user destroys own answer', js: true do
    sign_in(answer.user)
    visit question_path answer.question
    expect(page).to have_content answer.body
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario "Authenticated user can't destroy other user's answer", js: true do
    sign_in(user)
    visit question_path answer.question
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario "Non-authenticated user can't destroy any answer" do
    visit question_path answer.question
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end
end

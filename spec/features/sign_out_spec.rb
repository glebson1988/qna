require 'rails_helper'

feature 'Authenticated user can log out', %q{
  In order to be able to exit from my account
  As a authenticated user
  I want to be able to log out
} do
  given(:user) { create(:user) }

  scenario "Authenticated user can sign out" do
    sign_in(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end

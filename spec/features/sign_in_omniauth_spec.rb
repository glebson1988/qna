require 'rails_helper'

feature 'Authorization from providers', %q{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  given!(:user) { create(:user, email: 'already@user.com')}
  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario 'sign in user' do
      mock_auth_hash(:github, 'new@user.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth_hash(:github, email: nil)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'new@user.com'
      click_on 'Submit'

      open_email('new@user.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'sign in user' do
      mock_auth_hash(:vkontakte, 'new@user.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth_hash(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'new@user.com'
      click_on 'Submit'

      open_email('new@user.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'user enters incorrect email' do
      mock_auth_hash(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email'
      fill_in 'email', with: 'wrong_email'
      click_on 'Submit'

      expect(page).to have_content 'Enter your email'
      expect(page).to have_selector("input[type=submit][value='Submit']")
    end
  end
end
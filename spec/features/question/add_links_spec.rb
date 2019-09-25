require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url) { 'https://github.com' }
  given(:url2) { 'http://glebkaif.ru' }
  given(:gist_url) { 'https://gist.github.com/glebson1988/f98759463ccbd9ebc42ea503c80ffa34' }

  describe 'User asks question', js: true do
    before do
      sign_in user
      visit new_question_path
    end

    scenario 'with valid URL-link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'SomeLink'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'SomeLink', href: url
    end

    scenario 'with invalid URL-link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'SomeLink'
      fill_in 'Url', with: 'just URL'

      click_on 'Ask'

      expect(page).to have_content 'Links url must be a valid URL'
      expect(page).to_not have_content 'SomeLink'
      expect(page).to_not have_content 'just URL'
    end

    scenario 'with multiple links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'SomeLink'
      fill_in 'Url', with: url

      click_on 'add link'

      page.all('.nested-fields').last.fill_in 'Link name', with: 'SomeSecondLink'
      page.all('.nested-fields').last.fill_in 'Url', with: url2

      click_on 'Ask'

      expect(page).to have_link 'SomeLink', href: url
      expect(page).to have_link 'SomeSecondLink', href: url2
    end

    scenario 'with gist-link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'SomeLink'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content 'qnatest'
      expect(page).to_not have_link 'SomeLink', href: gist_url
    end
  end
end

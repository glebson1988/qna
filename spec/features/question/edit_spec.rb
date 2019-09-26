require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:url) { 'https://github.com' }

  describe 'Author of question', js: true do

    background do
      sign_in author
      visit questions_path
    end

    scenario 'edits his question' do
      within '.questions' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within '.questions' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'add files to edited question' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.questions' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link to edited question' do
      within '.questions' do
        click_on 'Edit'

        click_on 'add link'

        fill_in 'Link name', with: 'SomeLink'
        fill_in 'Url', with: url

        click_on 'Save question'

        expect(page).to have_link 'SomeLink', href: url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in user
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end

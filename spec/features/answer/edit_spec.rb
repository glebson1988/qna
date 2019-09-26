require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:url) { 'https://github.com' }

  describe 'Author of answer', js: true do

    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add files to edited answer' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.answers' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link to edited answer' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'

        click_on 'add link'

        fill_in 'Link name', with: 'SomeLink'
        fill_in 'Url', with: url

        click_on 'Save answer'

        expect(page).to have_link 'SomeLink', href: url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end

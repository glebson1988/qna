require 'rails_helper'

feature 'Attachments to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:question_with_attachment) { create(:question, :with_attachment, user: author) }

  describe 'Author of question' do
    background { sign_in author }

    scenario 'asks question with attached file', js: true do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete attached files from question', js: true do
      expect(page).to have_link question_with_attachment.filename
      within '.attachments' do
        click_on 'Delete file'
      end
      expect(page).to_not have_link question_with_attachment.filename
    end
  end

  scenario 'Not an author try to delete attached files from question', js: true do
    sign_in user
    visit questions_path

    expect(page).to have_link question_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
  end

  scenario 'Non authorized user try to delete attached files from question', js: true do
    visit questions_path

    expect(page).to have_link question_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
  end
end

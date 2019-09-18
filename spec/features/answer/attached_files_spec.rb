require 'rails_helper'

feature 'Attachments to answer', %q{
  In order to illustrate my answer
  As an author of question
  I'd like to be able to attach files
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, user: author) }
  given!(:answer_with_attachment) { create(:answer, :with_attachment, user: author) }

  describe 'Author of answer' do
    background { sign_in author }

    scenario 'create answer with attached file', js: true do
      visit question_path(answer.question)
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete attached files from answer', js: true do
      visit question_path(answer_with_attachment.question)
      expect(page).to have_link answer_with_attachment.filename
      within '.attachments' do
        click_on 'Delete file'
      end
      expect(page).to_not have_link answer_with_attachment.filename
    end
  end

  scenario 'Not an author try to delete attached files from answer', js: true do
    sign_in user
    visit question_path(answer_with_attachment.question)

    expect(page).to have_link answer_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
  end

  scenario 'Non authorized user try to delete attached files from answer', js: true do
    visit question_path(answer_with_attachment.question)

    expect(page).to have_link answer_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
  end
end

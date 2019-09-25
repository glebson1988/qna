require 'rails_helper'

feature 'User can delete links attached to question', %q{
  In order to provide ability delete unnecessary links of my question
  As an question's author
  I'd like to be able to delete links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question)}

  scenario 'Author deletes link from question', js: true do
    sign_in author
    visit question_path(question)

    within "#link_#{link.id}" do
      expect(page).to have_link link.name, href: link.url
      click_on "Delete link"
    end
    expect(page).to_not have_link link.name, href: link.url
  end

  scenario "Not an author of question can't delete question's link" do
    sign_in user
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url
    within "#link_#{link.id}" do
      expect(page).to_not have_content 'Delete link'
    end
  end

  scenario "Unauthorized user can't delete question's link" do
    visit question_path(question)

    within "#link_#{link.id}" do
      expect(page).to_not have_content "Delete link"
    end
  end
end

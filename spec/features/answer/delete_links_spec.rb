require 'rails_helper'

feature 'User can delete links attached to answer', %q{
  In order to provide ability delete unnecessary links of my answer
  As an answer's author
  I'd like to be able to delete links
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer) {create(:answer, question: question, user: answer_author) }
  given!(:link) { create(:link, linkable: answer)}

  scenario 'Author deletes link from answer', js: true do
    sign_in answer_author
    visit question_path(question)

    within "#answer_#{answer.id}" do
      within "#link_#{link.id}" do
        expect(page).to have_link link.name, href: link.url
        click_on 'Delete link'
      end
    end
    expect(page).to_not have_link link.name, href: link.url
  end

  scenario "Not an author of answer can't delete answer's link" do
    sign_in(question_author)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_content 'Delete link'
    end
  end

  scenario "Unauthorized user can't delete answer's link" do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_content 'Delete link'
    end
  end
end

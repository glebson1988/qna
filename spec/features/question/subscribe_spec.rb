require 'rails_helper'

feature 'User can subscribe on the question', %q{
    In order to have information about new answers
    As an authenticated user
    I would like to able to subscribe on the question
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user', js: true do
    describe "Author" do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'can unsubscribe', :vcr do
        within('.subscription') do
          expect(page).to_not have_content 'Subscribe'
          expect(page).to have_content 'Unsubscribe'

          click_on 'Unsubscribe'

          expect(page).to have_content 'Subscribe'
          expect(page).to_not have_content 'Unsubscribe'
        end
      end
    end

    describe "Another user" do
      background do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario "can subscribe" do
        within('.subscription') do
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'

          click_link 'Subscribe'

          expect(page).to have_content 'Unsubscribe'
          expect(page).to_not have_content 'Subscribe'
        end
      end
    end
  end

  describe "Non-authenticated user", js: true do
    background { visit question_path(question) }

    scenario "can't subscribe or unsubscribe" do
      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end

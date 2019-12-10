require 'rails_helper'
require 'sphinx_helper'

feature 'Search', %q{
  In order to be able to find information
  As an user
  I want be able to search by resources
} do

  given!(:questions) { create_list :question, 3 }
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:users) { create_list(:user, 3)}
  given!(:answer) { create(:answer) }
  given!(:answers) { create_list(:answer, 3)}
  given!(:comment) { create(:comment, commentable: question, user: user) }
  given(:comments) { create_list(:comment, 3, commentable: question, user: user) }

  describe 'Search by', js:true, sphinx: true do
    before { visit root_path }

    scenario 'question' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: question.title
        select 'question', from: 'scope'
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end

    scenario 'answer' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: answer.body
        select 'answer', from: 'scope'
        click_on 'Search'

        expect(page).to have_content answer.body

        answers.each do |a|
          expect(page).to_not have_content a.body
        end
      end
    end

    scenario 'comment' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: comment.body
        select 'comment', from: 'scope'
        click_on 'Search'

        expect(page).to have_content comment.body

        comments.each do |c|
          expect(page).to_not have_content c.body
        end
      end
    end

    scenario 'user' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: user.email
        select 'user', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        users.each do |u|
          expect(page).to_not have_content u.email
        end
      end
    end

    scenario 'thinking_sphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: user.email
        select 'thinking_sphinx', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        users.each do |u|
          expect(page).to_not have_content u.email
        end

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end
  end
end

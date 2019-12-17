require 'rails_helper'
require 'sphinx_helper'

feature 'Search', %q{
  In order to be able to find information
  As an user
  I want be able to search by resources
} do

  given!(:questions) { create_list :question, 2 }
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:users) { create_list(:user, 2)}
  given!(:answer) { create(:answer) }
  given!(:answers) { create_list(:answer, 2)}
  given!(:comment) { create(:comment, commentable: question, user: user) }
  given(:comments) { create_list(:comment, 2, commentable: question, user: user) }

  describe 'Search by', :vcr, js:true, sphinx: true do

    before do
      sign_in user
      visit root_path
    end

    scenario 'question' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: question.title
        select 'Question', from: 'scope'
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'answer' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: answer.body
        select 'Answer', from: 'scope'
        click_on 'Search'

        expect(page).to have_content answer.body

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'comment' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: comment.body
        select 'Comment', from: 'scope'
        click_on 'Search'

        expect(page).to have_content comment.body

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'user' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: user.email
        select 'User', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        users.each do |user|
          expect(page).to_not have_content user.email
        end

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end
      end
    end

    scenario 'all indicies' do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: user.email
        select 'All', from: 'scope'
        click_on 'Search'

        expect(page).to have_content user.email

        users.each do |user|
          expect(page).to_not have_content user.email
        end

        questions.each do |question|
          expect(page).to_not have_content question.title
        end
      end
    end
  end
end

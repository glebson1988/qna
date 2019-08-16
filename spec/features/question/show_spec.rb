require 'rails_helper'

feature 'User can see a question and answers to this question', %q{
  In order to help with question
  As an a user
  I want to able to to view question with it's answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_pair(:answer, question: question, user: user)}

  describe 'User' do
    background { visit question_path(question) }

    scenario 'sees detail of question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'sees answers to the question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end

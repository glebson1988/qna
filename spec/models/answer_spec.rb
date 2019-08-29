require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}

  it { should validate_presence_of(:body) }

  describe 'check set_best method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_answer) { create(:answer, question: question, user: user) }
    let(:answers) { create_list(:answer, 3, question: question, user: user)}

    it 'select answer as best' do
      answer.set_best!
      expect(answer).to be_best
    end

    it 'only one answer may be best' do
      answer.set_best!
      other_answer.set_best!
      expect(question.answers.where(best: :true).count).to eq 1
    end

    it 'best answer must be first in the list' do
      answers.last.set_best!
      expect(Answer.all.first).to be_best
    end
  end
end

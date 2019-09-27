require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'check set_best method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_reward, user: user) }
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
      expect(question.answers.first).to be_best
    end

    it 'should reward must belong to the user' do
      user.rewards.each { |reward| expect(reward.user_id).to eq user.id }
    end
  end
end

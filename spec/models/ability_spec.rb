require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      it { should be_able_to [:vote_up, :cancel_vote, :vote_down], create(:question, user: other) }
      it { should_not be_able_to [:vote_up, :cancel_vote, :vote_down], create(:question, user: user) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, question: question, user: user) }
      it { should_not be_able_to :update, create(:answer, question: question, user: other) }

      it { should be_able_to :destroy, create(:answer, question: question, user: user) }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

      it { should be_able_to [:vote_up, :cancel_vote, :vote_down], create(:answer, question: question, user: other) }
      it { should_not be_able_to [:vote_up, :cancel_vote, :vote_down], create(:answer, question: question, user: user) }

      it { should be_able_to :set_best, create(:answer, question: question, user: other) }
      it { should_not be_able_to :set_best, create(:answer, question: other_question, user: user) }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end
  end
end
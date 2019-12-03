require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create(:user) }

  describe 'Check authorship' do
    it 'current user is an author' do
      question = create(:question, user: user)

      expect(user).to be_author_of(question)
    end

    it 'current user is not an author' do
      question = create(:question)

      expect(user).to_not be_author_of(question)
    end
  end

  describe '#subscribed_of?' do
    let(:user_not_sub) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    it 'return true if user subscribed' do
      expect(user).to be_subscribed_of(question)
    end

    it 'return false if unsubscribed' do
      expect(user_not_sub).to_not be_subscribed_of(question)
    end
  end
end

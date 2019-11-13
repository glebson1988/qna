require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create(:user) }
  let(:auth) { mock_auth_hash(:github, user.email) }
  let(:authorization) { create(:authorization, 
                                user:user, 
                                provider: auth.provider, 
                                uid: auth.uid) }

  describe 'Services::FindForOauth' do
    subject { Services::FindForOauth }

    it 'calls that service' do
      expect(subject).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_authorization!' do
    it 'creates authorization for user' do
      expect { user.create_authorization!(auth) }.to change(user.authorizations, :count).by(1)
    end

    it 'creates authorization with provider' do
      expect(authorization.provider).to eq(auth.provider)
    end

    it 'creates authorization with uid' do
      expect(authorization.uid).to eq(auth.uid)
    end
  end

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
end

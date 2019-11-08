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
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  let(:service) { double('Services::FindForOauth') }

  it 'calls Services::FindForOauth' do
    expect(Services::FindForOauth).to receive(:new).and_return(service)
    expect(service).to receive(:call).with(auth)
    User.find_for_oauth(auth)
  end

  describe '.create_by' do
    let!(:user) { create(:user, email: 'already@user.com') }

    it 'create new user' do
      expect{ User.create_by('new@user.com') }.to change(User, :count).by(1)
    end

    it "don't create user if it already exists" do
      expect{ User.create_by('already@user.com') }.to_not change(User, :count)
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

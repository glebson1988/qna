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

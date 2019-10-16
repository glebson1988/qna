require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  it '#vote_up' do
    votable.vote_up(user)
    expect(Vote.last.value).to eq 1
    expect(Vote.last.user).to eq user
    expect(Vote.last.votable).to eq votable
  end

  it 'tries to vote up twice' do
    votable.vote_up(user)
    votable.vote_up(user)
    expect(votable.rating).to eq 1
  end

  it '#vote_down' do
    votable.vote_down(user)
    expect(Vote.last.value).to eq -1
    expect(Vote.last.user).to eq user
    expect(Vote.last.votable).to eq votable
  end

  it 'tries to vote down twice' do
    votable.vote_down(user)
    votable.vote_down(user)
    expect(votable.rating).to eq -1
  end

  it '#cancel_vote_of' do
    votable.vote_down(user)
    votable.cancel_vote_of(user)
    expect(votable.rating).to eq 0
  end

  it '#rating' do
    votable.vote_up(user)
    votable.vote_up(another_user)
    expect(votable.rating).to eq 2
  end

  describe '#vote_of?' do
    before { votable.vote_up(user) }

    it 'true if resource has vote from user' do
      expect(votable).to be_vote_of(user)
    end

    it 'false if resource has no vote from user' do
      expect(votable).to_not be_vote_of(another_user)
    end
  end
end

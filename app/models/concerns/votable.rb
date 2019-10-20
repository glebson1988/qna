module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create!(user: user, value: 1) unless vote_of?(user)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1) unless vote_of?(user)
  end

  def cancel_vote_of(user)
    votes.destroy_all if vote_of?(user)
  end

  def rating
    votes.sum(:value)
  end

  def vote_of?(user)
    votes.exists?(user: user)
  end
end

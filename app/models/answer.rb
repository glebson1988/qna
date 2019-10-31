class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.lock!.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end

class Answer < ApplicationRecord
  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.lock!.each { |answer| answer.lock!.update(best: false) }
      update!(best: true)
    end
  end
end

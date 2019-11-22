class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :best, :created_at, :updated_at, :question_id
end

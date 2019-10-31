class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def commentable
    klass = [Question, Answer].detect { |k| params["#{k.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def question_id
    return commentable.id if commentable.is_a?(Question)

    return commentable.question.id if commentable.is_a?(Answer)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_question_#{question_id}", comment: @comment)
  end
end

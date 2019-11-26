class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource class: Answer

  before_action :find_question, only: :index

  def index
    render json: @question.answers
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end

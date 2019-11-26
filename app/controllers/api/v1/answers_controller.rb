class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource class: Answer

  before_action :question, only: :index
  before_action :answer, only: %i[show]

  def index
    render json: @question.answers
  end

  def show
    render json: answer, serializer: AnswerSeparateSerializer
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer = Answer.find(params[:id])
  end
end

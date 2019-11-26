class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :question, only: %i[show]

  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: QuestionSeparateSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

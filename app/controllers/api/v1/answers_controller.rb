class Api::V1::AnswersController < Api::V1::BaseController

  skip_authorization_check

  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show update destroy]

  def index
    render json: @question.answers
  end

  def show
    render json: @answer, serializer: AnswerSeparateSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if @answer.update(answer_params)
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
    render json: { messages: ["Answer was successfully deleted."] }
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end

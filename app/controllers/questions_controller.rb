class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @comment = Comment.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      reward = @question.reward.present? ? ' with reward' : ' without reward'
      redirect_to @question, notice: "Your question successfully created#{reward}"
    else
      render :new
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions',
                                 question: @question)
  end
end

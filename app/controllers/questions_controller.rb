class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
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
                                     links_attributes: [:name, :url])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end

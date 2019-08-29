module AnswersHelper
  def show_best?(answer)
    current_user&.author_of?(answer.question) && !answer.best?
  end
end

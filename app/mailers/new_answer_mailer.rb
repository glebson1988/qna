class NewAnswerMailer < ApplicationMailer
  def new_notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end

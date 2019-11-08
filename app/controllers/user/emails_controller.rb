class User::EmailsController < ApplicationController
  
  def new; end

  def create
    if User.create_by(email).persisted?
      redirect_to new_user_session_path, notice: 'Check your email box for confirmation'
    else
      redirect_to new_user_session_path, notice: 'You can sign up'
    end
  end

  private

  def email
    params.require(:email)
  end
end
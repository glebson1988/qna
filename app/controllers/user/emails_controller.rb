class User::EmailsController < ApplicationController

  skip_authorization_check
  
  def new; end

  def create
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email, password: password, password_confirmation: password)
    
    if user.persisted?
      user.send_confirmation_instructions
    else
      render :new
    end
  end

  private

  def email
    params.require(:email)
  end
end
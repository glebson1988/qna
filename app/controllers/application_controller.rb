class ApplicationController < ActionController::Base
  before_action :gon_user

  def gon_user
    gon.user_id = current_user&.id
  end
end

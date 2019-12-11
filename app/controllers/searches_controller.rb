class SearchesController < ApplicationController

  skip_authorization_check

  def index
    if params[:query].present?
      @results = Services::Search.call(query_params)
    else
      render :index
    end
  end

  private

  def query_params
    params.permit(:query, :scope)
  end
end

class SearchesController < ApplicationController

  skip_authorization_check

  def index
    @query = query_params
    @results = Services::Search.call(@query)
    head :bad_request unless @results
  end

  private

  def query_params
    params.permit(:query, :scope)
  end
end

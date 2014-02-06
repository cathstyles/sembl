class SearchController < ApplicationController
  respond_to :html, :json

  def index
    @things = Services.search_service.search(Thing, Search::ThingQuery.new(search_params))
    respond_with @things
  end

  private

  def search_params
    params.permit(:text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :game_seed)
  end
end

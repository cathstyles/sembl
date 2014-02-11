class SearchController < ApplicationController
  respond_to :html, :json

  def index
    if search_params[:game_id]
      game = Game.find(search_params[:game_id])
      thing_query = game.filter_query
      thing_query.random_seed = game.random_seed
      @things = Services.search_service.search(Thing, thing_query)
    else
      @things = Services.search_service.search(Thing, Search::ThingQuery.new(search_params))
    end
    respond_with @things
  end

  private

  def search_params
    @search_params ||= params.permit(
      :game_id,
      :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :random_seed
    ).delete_if do |k,v|
      v.strip.empty?
    end
  end
end

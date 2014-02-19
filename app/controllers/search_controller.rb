class SearchController < ApplicationController
  respond_to :html, :json

  def index
    if search_params[:type] == "user"
      user = User.find_by_email(search_params[:email])
      render partial: "user", locals: {users: user ? [user] : []}
      elsif search_params[:game_id]
      game = Game.find(search_params[:game_id])
      thing_query = game.filter_query
      thing_query.random_seed = game.random_seed
      @things = Services.search_service.search(Thing, thing_query)
      respond_with @things
    else
      @things = Services.search_service.search(Thing, Search::ThingQuery.new(search_params))
      respond_with @things
    end
  end

  private

  def search_params
    @search_params ||= params.permit(
      :type, :email,
      :game_id,
      :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :random_seed
    ).delete_if do |k,v|
      v.strip.empty?
    end
  end
end

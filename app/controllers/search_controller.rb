class SearchController < ApplicationController
  respond_to :html, :json

  def index
    if search_params[:text]
      @things = Services.search_service.search(Thing, Search::ThingQuery.new(search_params))
    else
      @things = []
    end
    respond_with @things
  end

  private

  def search_params
    @search_params ||= params.permit(
      :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :game_seed
    ).delete_if do |k,v|
      v.strip.empty?
    end
  end
end

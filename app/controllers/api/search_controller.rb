class Api::SearchController < ApiController
  respond_to :json

  def index
    if search_params[:type] == "user"
      user = User.find_by_email(search_params[:email])
      render partial: "user", locals: {users: user ? [user] : []}
    else
      
      result = Services.search_service.search(Thing, Search::ThingQuery.new(search_params))
      @things = result[:hits]
      @total = result[:total]
      respond_with @things
    end
  end

  private

  def search_params
    @search_params ||= params.permit(
      :type, :email,
      :game_id,
      :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :random_seed,
      :offset, 
      :limit,
      :suggested_seed,
      :exclude_sensitive, :exclude_mature
    ).delete_if do |k,v|
      v.strip.empty?
    end
  end
end

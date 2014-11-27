class Api::SearchController < ApiController
  respond_to :json

  def index
    if search_params[:type] == "user"
      user = User.find_by_email(search_params[:email])
      render partial: "user", locals: {users: Array.wrap(user)}
    else
      search = ThingSearch.new(search_params)
      @things = search.results
      @total = search.total
      respond_with @things
    end
  end

  private

  def search_params
    params.permit(
      :type,          # Search type
      :email,         # User search params
      :access_filter, # Thing search params
      :created_to,
      :exclude_mature,
      :exclude_sensitive,
      :game_id,
      :include_user_contributed,
      :page,
      :place_filter,
      :random_seed,
      :suggested_seed,
      :text
    )
  end
end

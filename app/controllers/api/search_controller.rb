class Api::SearchController < ApiController
  respond_to :json

  def index
    if search_params[:type] == "user"
      user = User.find_by_email(search_params[:email])
      render partial: "user", locals: {users: Array.wrap(user)}
    else
      @search = ThingSearch.new(search_params)
      @fallback_search = fallback_search_class(@search).new(search_params)

      @things = @search.results
      @things = @things & @fallback_search.results.to_a if @search.requires_fallback? && @search.results_should_include_fallback?

      @total        = @search.total + @fallback_search.total
      @total_pages  = @search.results.total_pages + @fallback_search.results.total_pages
      @current_page = @search.page
      @per_page     = @search.per_page
    end
  end

  private

  def fallback_search_class(search)
    if %w(1 true).include?(params[:exclude_fallbacks].to_s) || !search.requires_fallback?
      ThingSearchNullFallback
    else
      ThingSearchFallback
    end
  end

  def search_params
    params.permit(
      :type,          # Search type
      :email,         # User search params
      :access_filter, # Thing search params
      :created_to,
      :exclude_fallbacks,
      :exclude_mature,
      :exclude_sensitive,
      :include_user_contributed,
      :page,
      :place_filter,
      :random_seed,
      :suggested_seed,
      :text
    )
  end
end

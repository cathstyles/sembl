class ThingSearch
  attr_accessor \
    :access_filter,
    :created_to,
    :exclude_mature,
    :exclude_sensitive,
    :include_user_contributed,
    :page,
    :place_filter,
    :random_seed,
    :suggested_seed,
    :text

  def initialize(params={})
    @text           = params[:text]
    @place_filter   = params[:place_filter]
    @access_filter  = params[:access_filter]

    if params[:created_to].present?
      @created_to = Date.parse(params[:created_to])
    end

    if params[:random_seed].present?
      @random_seed = params[:random_seed].to_i
    end

    @suggested_seed = %w(1 true).include?(params[:suggested_seed].to_s)

    @exclude_mature           = to_bool(params[:exclude_mature])
    @exclude_sensitive        = to_bool(params[:exclude_sensitive])
    @include_user_contributed = to_bool(params[:include_user_contributed])

    @page = (params[:page].presence || 1).to_i
  end

  def results
    query.results
  end

  def total
    query.total
  end

  def to_json
    # For saving to `game.filter_content_by`
    Jbuilder.encode do |json|
      json.text text                   if text.present?
      json.place_filter place_filter   if place_filter.present?
      json.access_filter access_filter if access_filter.present?
      json.created_to created_to       if created_to.present?
      json.random_seed random_seed     if random_seed.present?
      json.exclude_mature exclude_mature
      json.exclude_sensitive exclude_sensitive
      json.include_user_contributed include_user_contributed
    end
  end

  private

  def query
    @query ||= Thing.solr_search do
      if text.present?
        fulltext text, fields: %i(title description keywords dates node_type attribution copyright)
      end

      if exclude_mature
        with :mature, false
      end

      if exclude_sensitive
        with :sensitive, false
      end

      if include_user_contributed
        any_of do
          all_of do
            with :user_contributed, true
            with :moderator_approved, true
          end

          with :user_contributed, false
        end
      else
        with :user_contributed, false
      end

      if suggested_seed
        with :suggested_seed, true
      end

      if created_to.present?
        with(:created_at).less_than created_to
      end

      if place_filter.present?
        fulltext place_filter, fields: :places
      end

      if access_filter.present?
        fulltext access_filter, fields: :access_via
      end

      if random_seed.present?
        order_by :random, seed: random_seed
      end

      paginate page: page
    end
  end

  def to_bool(input)
    %w(1 true).include?(input.to_s)
  end
end

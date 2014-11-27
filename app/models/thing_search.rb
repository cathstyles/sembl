class ThingSearch
  attr_accessor \
    :access_filter,
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

    if params[:game_id].present?
      @game_id = params[:game_id].to_i
    end

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

  private

  def query
    @query ||= Thing.search do
      if text.present?
        fulltext text, fields: %i(title description general_attributes_keywords general_attributes_dates attribution copyright)
      end

      if game_id.present?
        with :game_id, game_id
      end

      if exclude_mature
        with :mature, false
      end

      if exclude_sensitive
        with :sensitive, false
      end

      unless include_user_contributed
        with :user_contributed, false
      end

      if suggested_seed
        with :suggested_seed, true
      end

      if created_to.present?
        with(:created_at).less_than created_to
      end

      if place_filter.present?
        fulltext place_filter, fields: :general_attributes_places
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
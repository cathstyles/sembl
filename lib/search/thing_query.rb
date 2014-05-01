class Search::ThingQuery
  attr_accessor :text, :place_filter, :access_filter, :date_from, :date_to, 
    :created_to, :random_seed, :offset, :limit, :suggested_seed,
    :exclude_sensitive, :exclude_mature

  def initialize(params)
    puts 'thing query params ' + params.inspect
    @text = params[:text] || "*"
    @place_filter = params[:place_filter]
    @access_filter = params[:access_filter]
    @date_from = Date.parse(params[:date_from])               if params[:date_from]
    @date_to = Date.parse(params[:date_to])                   if params[:date_to]
    @created_to = Date.parse(params[:created_to])             if params[:created_to]
    @random_seed = Integer(params[:random_seed])              if params[:random_seed]
    @suggested_seed = Integer(params[:suggested_seed])        if params[:suggested_seed]
    @game_id = Integer(params[:game_id])                      if params[:game_id]
    @exclude_mature = Integer(params[:exclude_mature])        if params[:exclude_mature]
    @exclude_sensitive = Integer(params[:exclude_sensitive])  if params[:exclude_sensitive]
    @offset = (Integer(params[:offset])                       if params[:offset]) || 0
    @limit = (Integer(params[:limit])                         if params[:limit]) || 10

    @text_fields  = ['title', 'description', 'general_attributes.Keywords']
    @date_field   = 'general_attributes.Date/s'
    @place_field  = 'general_attributes.Places'
    @access_field = 'access_via'
  end

  def build
    query_builder = Search::ElasticsearchQueryBuilder.new
    query_builder.text(@text_fields, text) unless !text
    query_builder.match_or_missing(:game_id, @game_id)
    query_builder.match(:mature, false) if exclude_mature == 1
    query_builder.match(:sensitive, false) if exclude_sensitive == 1
    query_builder.match(:suggested_seed, suggested_seed) unless !suggested_seed
    query_builder.range(@date_field, date_from, date_to) unless !(date_from || date_to)
    query_builder.range(:created_at, nil, created_to) unless !created_to
    query_builder.text([@place_field], place_filter) unless !place_filter
    query_builder.text([@access_field], access_filter) unless !access_filter
    query_builder.random_order(random_seed) unless !random_seed

    puts 'thing query query ' + query_builder.query.inspect
    return query_builder.query
  end

  def to_json
    # for saving to game.filter_content_by
    Jbuilder.encode do |json|
      json.text text unless not text
      json.place_filter place_filter unless not place_filter
      json.access_filter access_filter unless not access_filter
      json.date_from date_from.to_s unless not date_from
      json.date_to date_to.to_s unless not date_to
      json.created_to created_to.to_s unless not created_to
      json.random_seed random_seed.to_s unless not random_seed
      json.exclude_mature exclude_mature unless not exclude_mature
      json.exclude_sensitive exclude_sensitive unless not exclude_sensitive
    end
  end
end

class Search::ThingQuery
  attr_accessor :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :random_seed

  def initialize(params)
    @text = params[:text] || "*"
    @place_filter = params[:place_filter]
    @access_filter = params[:access_filter]
    @date_from = Date.parse(params[:date_from]) unless not params[:date_from]
    @date_to = Date.parse(params[:date_to]) unless not params[:date_to]
    @created_to = Date.parse(params[:created_to]) unless not params[:created_to]
    @random_seed = params[:random_seed]

    @text_fields = ['title', 'description', 'general_attributes.Keywords']
    @date_field = 'general_attributes.Date/s'
    @place_field = 'general_attributes.Places'
    @access_field = 'access_via'
  end

  def build
    query_builder = Search::ElasticsearchQueryBuilder.new
    query_builder.text(@text_fields, text) unless !text
    query_builder.range(@date_field, date_from, date_to) unless !(date_from || date_to)
    query_builder.range(:created_at, nil, created_to) unless !created_to
    query_builder.text([@place_field], place_filter) unless !place_filter
    query_builder.text([@access_field], access_filter) unless !access_filter
    query_builder.random_order(random_seed) unless !random_seed
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
    end
  end
end
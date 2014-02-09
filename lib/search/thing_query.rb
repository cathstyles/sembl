class Search::ThingQuery
  attr_accessor :text, :place_filter, :access_filter, :date_from, :date_to, :created_to, :game_seed

  def initialize(params)
    puts params.inspect
    @text = params[:text]
    @place_filter = params[:place_filter]
    @access_filter = params[:access_filter]
    @date_from = Date.parse(params[:date_from]) unless not params[:date_from]
    @date_to = Date.parse(params[:date_to]) unless not params[:date_to]
    @created_at_to = Date.parse(params[:created_to]) unless not params[:created_to]
    @game_seed = params[:game_seed]

    @text_fields = ['title', 'description', 'general_attributes.Keywords']
    @date_field = 'general_attributes.Date/s'
    @place_field = 'general_attributes.Places'
    @access_field = 'access_via'
  end

  def build
    query_builder = ElasticsearchQueryBuilder.new
    query_builder.text(@text_fields, text) unless !text
    query_builder.range(@date_field, date_from, date_to) unless !(date_from || date_to)
    query_builder.range(:created_at, nil, created_to) unless !created_to
    query_builder.text([@place_field], place_filter) unless !place_filter
    query_buidler.text([@access_field], access_filter) unless !access_filter
    query_builder.random_order(game_seed) unless !game_seed
    return query_builder.query
  end
end
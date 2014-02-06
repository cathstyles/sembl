class Search::BaseQuery
  attr_writer :query_builder

  def query_builder
    @query_builder ||= ElasticsearchQueryBuilder.new
  end
end
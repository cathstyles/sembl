class Search::ElasticSearchService
  require 'elasticsearch'

  def initialize(client_config={})
    @client_config = client_config
  end 

  def index(object)
    type = object.class.name.downcase
    client.index  index: 'sembl', type: type, id: object.id, body: object.to_json
  end

  def search(clazz, search_query)
    begin
      type = clazz.name.downcase
      body = {
        query: search_query.build,
        from: search_query.offset,
        size: search_query.limit
      }
      result = client.search index: 'sembl', type: type, body: body
      result_to_active_record(clazz, result)
    rescue Faraday::ConnectionFailed
      puts 'elasticsearch connection failed'
      @client = nil # reset client
      raise Services::ServiceError.new, 'Could not connect to search'
    rescue Elasticsearch::Transport::Transport::Errors::ServiceUnavailable
      raise Services::ServiceError.new, 'Search service unavailable'
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      puts e.inspect
      raise Services::ServiceError.new, 'Invalid search query'
    end
  end

  private

  def client
    @client ||= Elasticsearch::Client.new @client_config
  end

  def result_to_active_record(clazz, result)
    thing_ids = result['hits']['hits'].map do |hit|
      hit['_source']['id']
    end
    # preserve order
    clazz.find(thing_ids).index_by(&:id).slice(*thing_ids).values
  end
end

class Services
  class << self
    def search_service
      @search_service ||= Services::ElasticSearchService.new(Rails.application.config.elasticsearch)
    end
    
    def search_service=(service)
      @search_service = service
    end
  end

  class ElasticSearchService
    require 'elasticsearch'

    def initialize(client_config={})
      @client = Elasticsearch::Client.new client_config
    end 

    def index(object)
      type = object.class.name.downcase
      @client.index  index: 'sembl', type: type, id: object.id, body: object.to_json
    end

    def search(clazz, search_query)
      type = clazz.name.downcase
      body = {
        query: search_query.build
      }
      result = @client.search index: 'sembl', type: type, body: body
      result_to_active_record(clazz, result)
    end

    private

    def result_to_active_record(clazz, result)
      thing_ids = result['hits']['hits'].map do |hit|
        hit['_source']['id']
      end
      # preserve order
      clazz.find(thing_ids).index_by(&:id).slice(*thing_ids).values
    end
  end
end

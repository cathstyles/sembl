class Services
  class << self
    def search_service
      #@search_service ||= Search::ElasticSearchService.new(Rails.application.config.elasticsearch)
      @search_service ||= Services::StubSearchService.new
    end
    
    def search_service=(service)
      @search_service = service
    end
  end

  class StubSearchService
    def index(object)
    end

    def search(clazz, search_query)
      return clazz.all.offset(search_query.offset).limit(search_query.limit)
    end
  end
end
  
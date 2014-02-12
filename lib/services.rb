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
      puts search_query.build
      return clazz.all.limit(10)
    end
  end
end
  
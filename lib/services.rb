class Services
  class ServiceError < StandardError
  end

  class << self
    def search_service
      if Rails.application.config.elasticsearch[:host]
        @search_service ||= Search::ElasticSearchService.new(Rails.application.config.elasticsearch)
      else
        @search_service ||= Services::StubSearchService.new
      end
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
  
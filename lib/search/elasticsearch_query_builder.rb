class Search::ElasticsearchQueryBuilder
  def initialize
    @query = nil
  end

  def text(fields, text)
    @query = filter @query, { query_string: { fields: fields, query: text} }
  end

  def range(field, from, to)
    @query = filter @query, {
      range: {
        field => {
          gte: from,
          lte: to
        }
      }
    }
  end

  def random_order(seed)
    @query = {
      function_score: {
        functions: [
          {
            random_score: {
              seed: seed
            }
          }
        ],
        query: @query,
        boost_mode: :replace
      }
    }
  end
  
  def query
    @query
  end
  
  private
  
  def filter(query, filter)
    if query 
      {
        filtered: {
          query: query,
          filter: { query: filter }
        }
      }
    else
      filter
    end
  end
end
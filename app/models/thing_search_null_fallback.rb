class ThingSearchNullFallback
  def initialize(*)
  end

  def total
    0
  end

  def results
    Results.new
  end

  class Results
    def total_pages
      0
    end
  end
end

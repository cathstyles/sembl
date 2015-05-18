class ThingSearchFallback < ThingSearch
  def initialize(*)
    super

    @text           = negate_fulltext(text) if text.present?
    @place_filter   = negate_fulltext(place_filter) if place_filter.present?
    @access_filter  = negate_fulltext(access_filter) if access_filter.present?
  end

  def requires_fallback?
    false
  end

  private

  def negate_fulltext(text)
    text.gsub(/[^A-Za-z]/, "").split.map { |word| "-#{word}" }.join(" ")
  end
end

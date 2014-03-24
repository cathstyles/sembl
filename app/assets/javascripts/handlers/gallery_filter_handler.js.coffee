
class Sembl.Handlers.GalleryFilterHandler
  constructor: (@filter) ->
    @offset = 0
    @limit = 20
    @listeners = 
      'sembl.filter.change':        @listenerFilterChange
      'sembl.gallery.nextPage':     @listenerNextPage
      'sembl.gallery.previousPage': @listenerPreviousPage

  bind: () ->  
    @listeners
    $.each(
      @listeners
      (event_name, listener) -> $(window).bind(event_name, listener)
    )

  unbind: () ->
    $.each(
      @listeners
      (event_name, listener) -> $(window).unbind(event_name, listener)
    )

  handleSearch: () ->
    self = this
    params = 
      offset: @offset
      limit: @limit
    _.extend(params, @filter)

    things = $.getJSON("/api/search.json", 
      params
      (things) ->
        $(window).trigger('sembl.gallery.setState', {things: things})
    )

  listenerFilterChange: (event, filter) =>
    @filter = filter
    @offset = 0
    $.doTimeout('debounce.sembl.filter.change', 200, @handleSearch, filter)

  listenerNextPage: (event) =>
    @offset = @offset + @limit
    @handleSearch()

  listenerPreviousPage: (event) =>
    @offset = Math.max(0, @offset - @limit)
    @handleSearch()
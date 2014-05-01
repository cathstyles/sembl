###* @jsx React.DOM ###

@Sembl.Components.Searcher = React.createClass
  maxOffset: Number.MAX_VALUE
  defautLimit: 40

  getInitialState: ->
    offset: 0
    limit: @defautLimit
    filter: @props.filter

  componentWillMount: ->
    @subscriberTokens = []
    if !@props.prefix
      log.error 'Searcher needs prefix prop for events, got props', @props

    $(window).on("#{@props.prefix}.search", @search)
    $(window).on("#{@props.prefix}.notify", @handleNotify)
    $(window).on("#{@props.prefix}.setFilter", @handleSetFilter)
    $(window).on("#{@props.prefix}.nextPage", @handleNextPage)
    $(window).on("#{@props.prefix}.previousPage", @handlePreviousPage)

  componentWillUnmount: ->
      $(window).off("#{@props.prefix}.search", @search)
      $(window).off("#{@props.prefix}.notify", @handleNotify)
      $(window).off("#{@props.prefix}.setFilter", @handleSetFilter)
      $(window).off("#{@props.prefix}.nextPage", @handleNextPage)
      $(window).off("#{@props.prefix}.previousPage", @handlePreviousPage)

  componentDidMount: ->
    @search()

  componentDidUpdate: ->
    $.doTimeout("debounce.#{@props.prefix}.search", 200, @search)

  search: ->
    offset = @state.offset
    params =
      offset: offset
      limit: @state.limit
      game_id: @props.game.id
    _.extend(params, @state.filter)
    console.log 'searching', params
    $.ajax(
      url: "/api/search.json"
      data: params
      type: 'GET'
      dataType: 'json'
      error: (response) =>
        console.error 'error when searching', response.responseText
        @results = []
        @handleNotify()
      success: (data) =>
        total = data.total
        things = data.hits
        if things.length == 0
          @maxOffset = offset
        hits = for i,thing of things
          index: offset + Number.parseInt(i)
          thing: thing

        @results = 
          total: total
          hits: hits

        @handleNotify()
    )

  handleSetFilter: (event, filter) ->
    @setState
      filter: filter
      offset: 0

  handleNotify: ->
    results = @results || []
    if @props.prefix
      $(window).trigger("#{@props.prefix}.updated", {results: results, offset: @state.offset, limit: @state.limit})

  handleNextPage: (event) ->
    @search
    offset = Math.min(@maxOffset, @state.offset + @state.limit)
    if offset != @state.offset
      @setState
        offset: offset

  handlePreviousPage: (event) ->
    if @state.offset > 0
      @setState
        offset: Math.max(0, @state.offset - @state.limit)

  render: ->
    `<div dataOffset={this.state.offset} dataLimit={this.state.limit} dataFilter={this.state.filter} />`

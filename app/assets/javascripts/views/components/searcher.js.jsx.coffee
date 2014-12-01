###* @jsx React.DOM ###

@Sembl.Components.Searcher = React.createClass
  getInitialState: ->
    page: 1
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
    params = {page: @state.page}
    _.extend(params, @state.filter)
    $.ajax(
      url: "/api/search.json"
      data: params
      type: 'GET'
      dataType: 'json'
      error: (response) =>
        console.error 'error when searching', response.responseText
        @results = {}
        @handleNotify()
      success: (data) =>
        # The offset is used to keep images in a stable position in an array
        # when a parent component uses the searcher to work on multiple pages
        # of results.
        offset = ((data.page - 1) * data.per_page) + 1

        hits = for i,thing of data.hits
          index: offset + parseInt(i)
          thing: thing

        @results =
          total: data.total
          hits: hits

        @handleNotify()
    )

  handleSetFilter: (event, filter) ->
    @setState
      filter: filter
      page: 1

  handleNotify: ->
    results = @results || {}
    if @props.prefix
      $(window).trigger("#{@props.prefix}.updated", {results: results, page: @state.page})

  handleNextPage: (event) ->
    @setState({page: @state.page + 1})
    @search()

  handlePreviousPage: (event) ->
    if @state.page > 1
      @setState({page: @state.page - 1})
    @search()

  render: ->
    `<div dataOffset={this.state.offset} dataLimit={this.state.limit} dataFilter={this.state.filter} />`

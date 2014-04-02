###* @jsx React.DOM ###

@Sembl.Components.Searcher = React.createClass
  getInitialState: ->
    offset: 0
    limit: 20
    filter: @props.filter

  componentWillMount: ->
    if @props.prefix
      $(window).on("#{@props.prefix}.search", @search)
      $(window).on("#{@props.prefix}.notify", @handleNotify)
      $(window).on("#{@props.prefix}.setState", @handleSetState)
      $(window).on("#{@props.prefix}.nextPage", @handleNextPage)
      $(window).on("#{@props.prefix}.previousPage", @handlePreviousPage)

  componentWillUnmount: ->
      $(window).off("#{@props.prefix}.search")
      $(window).off("#{@props.prefix}.notify")
      $(window).off("#{@props.prefix}.setState")
      $(window).off("#{@props.prefix}.nextPage")
      $(window).off("#{@props.prefix}.previousPage")

  componentDidMount: ->
    @search()

  componentDidUpdate: ->
    $.doTimeout("debounce.#{@props.prefix}.search", 200, @search)

  search: ->
    params =
      offset: @state.offset
      limit: @state.limit
    _.extend(params, @state.filter)
    console.log "#{@props.prefix}.search", params
    $.getJSON("/api/search.json",
      params
      (things) =>
        @things = things
        @handleNotify()
    )

  handleSetState: (event, newState) ->
    @setState newState

  handleNotify: ->
    if @props.prefix
      $(window).trigger("#{@props.prefix}.updated", {things: @things})

  handleNextPage: (event) ->
    @setState
      offset: @state.offset + @state.limit

  handlePreviousPage: (event) ->
    if @state.offset > 0
      @setState
        offset: Math.max(0, @state.offset - @state.limit)

  render: ->
    `<div dataOffset={this.state.offset} dataLimit={this.state.limit} dataFilter={this.state.filter} />`

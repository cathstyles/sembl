#= require views/components/searcher

###* @jsx React.DOM ###

{Searcher} = Sembl.Components

@Sembl.Games.Setup.StepFilter = React.createClass
  searcherPrefix: "setup.steps.filter.searcher"

  componentWillMount: ->
    $(window).on("#{@searcherPrefix}.updated", @handleSearcherUpdated)

  componentWillUnmount: ->
    $(window).off("#{@searcherPrefix}.updated")

  getInitialState: () ->
    filter:
      text: this.props.filter?.text
      place_filter: this.props.filter?.place_filter
      access_filter: this.props.filter?.access_filter

  handleSearcherUpdated: (event, results) ->
    console.log 'handleSearcherUpdated', results

  handleChange: (event) ->
    filter =
      text: this.refs.text.getDOMNode().value || null;
      place_filter: this.refs.place_filter.getDOMNode().value || null
      access_filter: this.refs.access_filter.getDOMNode().value || null
    this.setState
      filter: filter
    $(window).trigger("#{@props.searcherPrefix}.setState", {filter: filter})
    $(window).trigger('setup.steps.change', {filter: filter})
    event.preventDefault()
  
  isValid: ->
    # TODO: is results non empty?
    true

  render: () ->
    filter = this.state.filter;
    
    `<div className={this.className}>
      <Searcher filter={filter} prefix={this.searcherPrefix} />
      <div>Set filters to restrict the available images in the game</div>
      <div className="games-setup__filter">
        <label className="games-setup__filter-label" htmlFor="filter-text">Text:</label>
        <input type="text" ref="text" value={filter.text} id="filter-text" onChange={this.handleChange} className="games-setup__filter-input"/>
      </div>
      <div className="games-setup__filter">
        <label className="games-setup__filter-label" htmlFor="filter-place">Place:</label>
        <input type="text" ref="place_filter" value={filter.place_filter} id="filter-place" onChange={this.handleChange} className="games-setup__filter-input"/>
      </div>
      <div className="games-setup__filter">
        <label className="games-setup__filter-label" htmlFor="filter-access">Source:</label>
        <input type="text" ref="access_filter" value={filter.access_filter} id="filter-access" onChange={this.handleChange} className="games-setup__filter-input"/>
      </div>
    </div>`

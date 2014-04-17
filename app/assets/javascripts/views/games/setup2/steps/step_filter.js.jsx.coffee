#= require views/components/searcher
#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{Searcher, ThingModal} = Sembl.Components
{Gallery} = Sembl.Games

@Sembl.Games.Setup.StepFilter = React.createClass
  searcherPrefix: "setup.steps.filter.searcher"
  galleryPrefix: "setup.steps.filter.gallery"

  componentWillMount: ->
    $(window).on("#{@searcherPrefix}.updated", @handleSearcherUpdated)
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)

  componentWillUnmount: ->
    $(window).off("#{@searcherPrefix}.updated")
    $(window).off("#{@galleryPrefix}.thing.click")

  getInitialState: () ->
    filter:
      text: this.props.filter?.text
      place_filter: this.props.filter?.place_filter
      access_filter: this.props.filter?.access_filter

  handleSearcherUpdated: (event, results) ->
    console.log 'handleSearcherUpdated', results

  handleGalleryThingClick: (event, thing) ->
    $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

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
    filterText = if (!filter.text || filter.text == "*") then null else filter.text
    
    `<div className="setup__steps__filters">
      <div className="setup__steps__title">Set filters to restrict available game images:</div>
      <div className="setup__steps__inner">
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-text">Text:</label>
          <input className="setup__steps__filters__filter__input" type="text" ref="text" value={filterText} id="filter-text" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-place">Place:</label>
          <input className="setup__steps__filters__filter__input" type="text" ref="place_filter" value={filter.place_filter} id="filter-place" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-access">Source:</label>
          <input className="setup__steps__filters__filter__input" type="text" ref="access_filter" value={filter.access_filter} id="filter-access" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
      </div>
      <div className="setup__steps__filters__available">These images will be available:</div>
      <div className="setup__steps__filters__gallery">
        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
      <Searcher filter={filter} prefix={this.searcherPrefix} />
    </div>`

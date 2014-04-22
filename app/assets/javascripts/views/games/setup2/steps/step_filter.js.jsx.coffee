#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Gallery} = Sembl.Games

@Sembl.Games.Setup.StepFilter = React.createClass
  galleryPrefix: "setup.steps.filter.gallery"

  componentWillMount: ->
    $(window).on("#{@props.searcherPrefix}.updated", @handleSearcherUpdated)
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)

  componentWillUnmount: ->
    $(window).off("#{@props.searcherPrefix}.updated")
    $(window).off("#{@galleryPrefix}.thing.click")

  getInitialState: () ->
    filter: this.props.filter

  handleSearcherUpdated: (event, results) ->
    # TODO: Results needs to return a number for the total results, so we know how many there are all together, not just in this page.
    # then we can validate the filter only when the results are not empty. Or at least show the user of the count.

  handleGalleryThingClick: (event, thing) ->
    $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  handleChange: (event) ->
    filter =
      text: this.refs.text.getDOMNode().value || null;
      place_filter: this.refs.place_filter.getDOMNode().value || null
      access_filter: this.refs.access_filter.getDOMNode().value || null
    this.setState
      filter: filter
    $(window).trigger("#{@props.searcherPrefix}.setFilter", filter)
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
        <Gallery searcherPrefix={this.props.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`

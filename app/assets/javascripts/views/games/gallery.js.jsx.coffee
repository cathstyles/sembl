#= require jquery.isotope
#= require imagesloaded.pkgd

###* @jsx React.DOM ###

{GalleryThingSelected} = @Sembl.Games
{ToggleComponent} = @Sembl.Components
@Sembl.Games.GalleryThing = React.createClass
  className: "games__gallery__thing"

  getInitialState: () ->
    selected: false
    width: null

  handleClick: (event) ->
    console.log "#{@props.eventPrefix}.thing.click"
    $(window).trigger("#{@props.eventPrefix}.thing.click", @props.thing)

  componentDidMount: ->
    imagesLoaded(@getDOMNode(), =>
      $(window).trigger("#{@props.eventPrefix}.thing.loaded")
    )

  render: () ->
    thing = this.props.thing;
    `<img className={this.className}
        height="150px" width={this.state.width}
        src={thing.image_browse_url}
        onClick={this.handleClick} />`

{GalleryThing} = Sembl.Games
@Sembl.Games.Gallery = React.createClass
  className: "games__gallery"

  getInitialState: () ->
    things: []
    first: false

  componentWillMount: () ->
    $(window).on("#{@props.eventPrefix}.setState", @listenSetState)
    $(window).on("#{@props.eventPrefix}.thing.loaded", @handleThingLoaded)
    $(window).on("#{@props.searcherPrefix}.updated", @handleSearchUpdated)

  componentWillUnmount: () ->
    $(window).off("#{@props.eventPrefix}.setState")
    $(window).off("#{@props.eventPrefix}.loaded")
    $(window).off("#{@props.searcherPrefix}.updated")

  handleThingLoaded: ->
    $.doTimeout('debounce.gallery.isotope', 50, =>
      $(@refs.things.getDOMNode()).isotope({
        itemSelector : '.games__gallery__thing'
        layoutMode: 'fitRows',
      })
    )

  handleSearchUpdated: (event, data) ->
    @setState data

  listenSetState: (event, subState) ->
    @setState subState

  handleNextPage: (event) ->
    $(window).trigger("#{@props.searcherPrefix}.nextPage")
    event.preventDefault()

  handlePreviousPage: (event) ->
    $(window).trigger("#{@props.searcherPrefix}.previousPage")
    event.preventDefault()

  render: () ->
    # Sub component dom elements don't exist in this.componentDidMount, but they do exist in this.componentDidUpdate
    # So we ensure we render twice, because we need the images to have been loaded before we do the positioning as we don't know their dimensions.
    if not @state.first
      @setState
        first: true

    self = this
    things = this.state.things.map (thing) ->
      `<GalleryThing key={thing.id} thing={thing} eventPrefix={self.props.eventPrefix} />`

    `<div className={this.className}>
      <button onClick={this.handlePreviousPage} className={this.className + "__previous"}><i className="fa fa-chevron-left"></i> Previous page</button>
      <button onClick={this.handleNextPage} className={this.className + "__next"}>Next page <i className="fa fa-chevron-right"></i></button>
      <div ref="things" className={this.className + "__things"}>
        {things}
      </div>
    </div>`

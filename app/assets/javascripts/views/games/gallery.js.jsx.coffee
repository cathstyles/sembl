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
    $(window).trigger('gallery.thing.click', @props.thing)

  componentDidMount: ->
    imagesLoaded(@getDOMNode(), =>
      $(window).trigger('gallery.thing.loaded')
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
    $(window).on('sembl.gallery.setState', @listenSetState)
    $(window).on('gallery.thing.loaded', @handleThingLoaded)

  handleThingLoaded: ->
    $.doTimeout('debounce.gallery.isotope', 50, =>
      $(@refs.things.getDOMNode()).isotope({
        itemSelector : '.games__gallery__thing'
        layoutMode: 'fitRows',
      })
    )

  componentWillUnmount: () ->
    $(window).off('sembl.gallery.setState')

  listenSetState: (event, subState) ->
    @setState subState

  handleNextPage: (event) ->
    $(window).trigger('sembl.gallery.nextPage')
    event.preventDefault()

  handlePreviousPage: (event) ->
    $(window).trigger('sembl.gallery.previousPage')
    event.preventDefault()

  render: () ->
    # ensure we render twice, so that the gallery things exist as 
    # they don't exist yet in componentDidMount, but they do exist in componentDidUpdate
    if not @state.first
      @setState 
        first: true
    
    self = this
    requests = this.props.requests
    things = this.state.things.map (thing) ->
      if requests
        _.extend(thing, requests)
      `<GalleryThing key={thing.id} thing={thing} SelectedClass={self.props.SelectedClass} />`

    `<div className={this.className}>
      <button onClick={this.handlePreviousPage} className={this.className + "__previous"}><i className="fa fa-chevron-left"></i> Previous page</button>
      <button onClick={this.handleNextPage} className={this.className + "__next"}>Next page <i className="fa fa-chevron-right"></i></button>
      <div ref="things" className={this.className + "__things"}>
        {things}
      </div>
    </div>`

#= require views/components/toggle_component
###* @jsx React.DOM ###

{GalleryThingSelected} = @Sembl.Games
{ToggleComponent} = @Sembl.Components
@Sembl.Games.GalleryThing = React.createClass
  className: "games__gallery__thing"

  getInitialState: () ->
    selected: false

  handleClick: (event) ->
    this.refs.selected_modal.handleToggle()
    console.log "selected"
    event.preventDefault();
    
  render: () ->
    thing = this.props.thing;

    selectedModal = ToggleComponent
      ref: "selected_modal"
      toggle: this.state.selected
      OffClass: null
      OnClass: this.props.SelectedClass
      onProps:
        thing: this.props.thing

    `<div className={this.className}>
      <img src={thing.image_browse_url} onClick={this.handleClick} />
      {selectedModal}
    </div>`

{GalleryThing} = Sembl.Games
@Sembl.Games.Gallery = React.createClass
  className: "games__gallery"

  getInitialState: () ->
    things: []

  componentWillMount: () ->
    $(window).bind('sembl.gallery.setState', @listenSetState)

  componentWillUnmount: () ->
    $(window).unbind('sembl.gallery.setState')

  listenSetState: (event, subState) ->
    @setState subState

  handleNextPage: (event) ->
    $(window).trigger('sembl.gallery.nextPage')
    event.preventDefault()

  handlePreviousPage: (event) ->
    $(window).trigger('sembl.gallery.previousPage')
    event.preventDefault()

  render: () ->
    self = this
    requests = this.props.requests
    things = this.state.things.map (thing) ->
      if requests
        _.extend(thing, requests)
      `<GalleryThing key={thing.id} thing={thing} SelectedClass={self.props.SelectedClass} />`

    `<div className={this.className}>
      <button onClick={this.handlePreviousPage}>Previous page</button>
      <button onClick={this.handleNextPage}>Next page</button>
      <div className={this.className + "__row"}>
        {things}
      </div>
    </div>`

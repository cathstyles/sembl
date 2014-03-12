#= require views/components/toggle_component
###* @jsx React.DOM ###

{GalleryThingSelected} = @Sembl.Games
{ToggleComponent} = @Sembl.Components
@Sembl.Games.GalleryThing = React.createClass
  className: "games__gallery__thing"

  getInitialState: () ->
    selected: false

  handleClick: (event) ->
    $(window).trigger('toggle.gallery.thing.' + @props.thing.id, {flag: on})

  render: () ->
    thing = this.props.thing;

    selectedModal = ToggleComponent
      ref: "selected_modal"
      OffClass: null
      OnClass: this.props.SelectedClass
      thing: this.props.thing
      toggleEvent: 'toggle.gallery.thing.' + thing.id

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
      <button onClick={this.handlePreviousPage} className={this.className + "__previous"}><i className="fa fa-chevron-left"></i> Previous page</button>
      <button onClick={this.handleNextPage} className={this.className + "__next"}>Next page <i className="fa fa-chevron-right"></i></button>
      <div className={this.className + "__row"}>
        {things}
      </div>
    </div>`

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

    `<div className={this.classString}>
      {thing.title}<br/>
      <img src={thing.image_admin_url} height="200" width="200" onClick={this.handleClick} />
      {selectedModal}
    </div>`

{GalleryThing} = Sembl.Games
@Sembl.Games.Gallery = React.createClass
  className: "games__gallery"

  getInitialState: () ->
    filter: this.props.filter
    things: []

  componentWillMount: () ->
    this.handleSearch(this.props.query);

  handleSearch: (query) ->
    self = this
    requests = this.props.requests
    things = $.getJSON("/api/search.json", 
      this.state.filter,
      (things) ->
        if requests
          things = things.map (thing) ->
            _.extend(thing, requests)
        self.setState
          things: things
    )

  render: () ->
    self = this
    things = this.state.things.map (thing) ->
      `<GalleryThing key={thing.id} thing={thing} SelectedClass={self.props.SelectedClass} />`

    `<div className={this.className}>
      {things}
    </div>`

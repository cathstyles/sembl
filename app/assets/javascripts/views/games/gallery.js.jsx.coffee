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
    filter: this.props.filter
    things: []
    offset: 0
    limit: 10

  handleNextPage: (event) ->
    console.log "next page!"
    offset = this.state.offset + this.state.limit
    limit  = this.state.limit
    this.setState
      offset: offset
    this.handleSearch(this.state.filter, offset, limit)
    event.preventDefault()

  handlePreviousPage: (event) ->
    console.log "previous page!"
    offset = Math.max(0, this.state.offset - this.state.limit)
    limit  = this.state.limit
    this.setState
      offset: offset
    this.handleSearch(this.state.filter, offset, limit)
    event.preventDefault()

  filterUpdateListener: (event, filter) ->
    console.log event, data

  componentWillMount: () ->
    this.handleSearch(this.props.filter)
    $(window).on(
      "filter:update"
      this.listenFilterUpdates
    )

  handleSearch: (query, offset, limit) ->
    self = this
    params = 
      offset: offset
      limit: limit
    _.extend(params, query)
    requests = this.props.requests
    things = $.getJSON("/api/search.json", 
      params      
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
      <button onClick={this.handlePreviousPage}>Previous page</button>
      <button onClick={this.handleNextPage}>Next page</button>
      <div className={this.className + "__row"}>
        {things}
      </div>
    </div>`

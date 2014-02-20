###* @jsx React.DOM ###

@Sembl.Games.GalleryThing = React.createClass
  className: "games__gallery__thing"
  render: () ->
    thing = this.props.thing;
    `<div className={this.classString}>
      {thing.title}<br/>
      <img src={thing.image.url} height="200" width="200" />
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
    things = $.getJSON("/search.json", 
      this.state.filter,
      (data) ->
        self.setState
          things: data
    )

  render: () ->
    things = this.state.things.map (thing) ->
      `<GalleryThing key={thing.id} sthing={thing} />`

    `<div className={this.className}>
      {things}
    </div>`

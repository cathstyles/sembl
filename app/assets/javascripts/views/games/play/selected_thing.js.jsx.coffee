###* @jsx React.DOM ###

@Sembl.Games.Play.SelectedThing = React.createClass
  className: "games__play__selected_thing"

  render: () ->
    thing = this.props.thing
    `<div className={this.className}>
      <button>Choose "{thing.title}" for something</button>
    </div>`
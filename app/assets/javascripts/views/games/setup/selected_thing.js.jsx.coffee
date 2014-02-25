###* @jsx React.DOM ###

@Sembl.Games.Setup.SelectedThing = React.createClass
  className: "games__setup__selected_thing"

  render: () ->
    thing = this.props.thing
    `<div className={this.className}>
      <button>Choose "{thing.title}" for something</button>
    </div>`
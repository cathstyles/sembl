###* @jsx React.DOM ###

@Sembl.Games.Setup.SelectedThing = React.createClass
  className: "games__setup__selected_thing"

  handleSelectSeed: () ->
    thing = this.props.thing
    if thing.requestSelectSeed
      thing.requestSelectSeed(thing)

  render: () ->
    thing = this.props.thing
    
    `<div className={this.className}>
      <button onClick={this.handleSelectSeed}>Select "{thing.title}" as seed</button>
    </div>`

###* @jsx React.DOM ###

@Sembl.Games.Setup.SelectedThing = React.createClass
  className: "games__setup__selected_thing"

  handleSelectSeed: () ->
    event.preventDefault()
    thing = this.props.thing
    if thing.requestSelectSeed
      thing.requestSelectSeed(thing)

  render: () ->
    thing = this.props.thing

    `<div className={this.className}>
      <a onClick={this.handleSelectSeed} className="games__setup__selected_thing-set-as-seed-node" href="#"><i className="fa fa-check"></i> <em>Set as seed node</em></a>
      <em className="games__setup__selected_thing-or">Or</em>
      <a className="games__setup__selected_thing-exclude-from-game" href="#"><i className="fa fa-times"></i> <em>Exclude from game</em></a>
    </div>`

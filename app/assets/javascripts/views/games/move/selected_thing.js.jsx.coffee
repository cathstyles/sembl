###* @jsx React.DOM ###

@Sembl.Games.Move.SelectedThing = React.createClass
  className: "games__play__selected_thing"

  handleSelectThing: (event) ->
    this.props.thing.requestSelectThing(this.props.thing)
    event.preventDefault()

  render: () ->
    thing = this.props.thing

    `<div className={this.className}>
      <button onClick={this.handleSelectThing}>Place "{thing.title}"</button>
    </div>`
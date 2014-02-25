###* @jsx React.DOM ###

@Sembl.Games.Move.MoveMaker = React.createClass
  className: "games__play__move-maker"

  getInitialState: () ->
    move = new Sembl.Move()
    move.game_id = this.props.game.id

    {
      move: move
      target: null
    }

  handleSubmitMove: () ->
    params = {move: this.state.move}
    console.log params
    url = "/api/moves.json"
    # TODO: this shoudl be POST, but get is helpful for debugging.
    $.get(
      url
      params,
      (move_status) ->
        console.log move_status
      "json"
    )

  handleSelectThing: (thing) ->
    this.state.move.setTarget(1, thing.id)
    this.setState
      move: this.state.move

  render: () ->
    `<div className={this.className}>
      <button onClick={this.handleSubmitMove}>Submit Move</button>
    </div>`
    

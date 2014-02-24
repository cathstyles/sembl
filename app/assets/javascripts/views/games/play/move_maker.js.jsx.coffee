###* @jsx React.DOM ###

@Sembl.Games.Play.MoveMaker = React.createClass
  className: "games__play__move-maker"

  getInitialState: () ->
    move = new Sembl.Move()
    move.game_id = this.props.game.id

    {
      move: move
    }

  handleSubmitMove: () ->
    params = {move: this.state.move}
    url = "/api/moves.json"
    # TODO: this shoudl be POST, but get is helpful for debugging.
    $.get(
      url
      params,
      (move_status) ->
        console.log move_status
      "json"
    )

  render: () ->
    `<div className={this.className}>
      <button onClick={this.handleSubmitMove}>Submit Move</button>
    </div>`
    

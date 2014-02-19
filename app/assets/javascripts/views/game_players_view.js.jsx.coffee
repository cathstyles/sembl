###* @jsx React.DOM ###

Sembl.GamePlayersView = React.createClass
  render: -> 
    players = @props.players.map((player) ->
      return `<li key={player.cid}>{player.get('user').email}</li>`
    )
    return `<ul className="board__header__players">
        {players}
      </ul>`

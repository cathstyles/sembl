###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlayersView = React.createClass
  render: -> 
    players = @props.players.map((player) ->
      return `<li key={player.cid}>{player.get('user').email}</li>`
    )
    return `<ul className="board__header__players">
        {players}
      </ul>`

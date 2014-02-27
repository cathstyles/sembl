###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlayersView = React.createClass
  render: -> 
    players = @props.players.map((player) ->
      `<li key={player.cid}>{player.get('user').email}</li>`
    )
    
    `<ul className="game__players">
        {players}
      </ul>`

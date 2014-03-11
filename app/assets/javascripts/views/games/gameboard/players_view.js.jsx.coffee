###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlayersView = React.createClass
  render: -> 
    players = @props.players.map((player) ->
      `<li key={player.cid} className="game__player">
          <div className="game__player__details">
            <img src="http://placekitten.com/60/60" width="60" height="60" />
            <em>{player.get('user').email}</em>
          </div>
        </li>`
    )
    
    `<ul className="game__players">
        {players}
      </ul>`

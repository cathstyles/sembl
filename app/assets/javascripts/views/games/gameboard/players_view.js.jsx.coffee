###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlayersView = React.createClass
  render: -> 
    # TODO: We should increment this number for each player unless we can implement avatars
    # Can also use the .player--highlighted class to indicate "you"
    players = @props.players.map((player) ->
      `<li key={player.cid} className="game__player">
          <div className="game__player__details">
            <span className="game__player__details__avatar">1</span>
            <em>{player.get('user').email}</em>
          </div>
        </li>`
    )
    
    `<ul className="game__players">
        <li className="game__player game__player--icon">
          <i className="fa fa-smile-o"></i>
        </li>
        {players}
      </ul>`

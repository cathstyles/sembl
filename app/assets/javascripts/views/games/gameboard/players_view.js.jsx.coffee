###* @jsx React.DOM ###

@Sembl.Games.Gameboard.PlayersView = React.createClass
  getAvatar: (user) -> 
    if user.avatar and user.avatar.avatar_tiny_thumb
      `<img src={user.avatar.avatar_tiny_thumb} />` 
    else 
      # Get initials from name
      _.map(user.name.split(' ', 2), (item) -> 
        item[0].toUpperCase()
      ).join('')

  getNameAndStatus: (player) -> 
    state = player.get('state').replace('_', ' ')
    "#{player.get('user').name}, #{state}"

  render: -> 
    # Can also use the .player--highlighted class to indicate "you"
    # Added, needs styles
    players = @props.players.map((player) =>
      user = player.get('user')
      highlighted = if window.Sembl.user.email is user.email then " player--highlighted" else ""
      avatar = @getAvatar(user)
      nameAndStatus = @getNameAndStatus(player)

      `<li key={player.cid} className="game__player">
          <div className="game__player__details">
            <span className={"game__player__details__avatar" + highlighted}>
              {avatar}
            </span>
            <em>{nameAndStatus}</em>
            <span className="game__player__details__score">
              {player.get('score')}
            </span>
          </div>
        </li>`
    )
    
    `<ul className="game__players">
        <li className="game__player game__player--icon">
          <i className="fa fa-smile-o"></i>
        </li>
        {players}
      </ul>`

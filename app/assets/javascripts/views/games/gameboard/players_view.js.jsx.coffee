###* @jsx React.DOM ###

@Sembl.Games.Gameboard.PlayersView = React.createClass
  getAvatar: (user) ->
    if user.avatar_tiny_thumb
      `<img src={user.avatar_tiny_thumb} />`
    else
      name = if user.name? && user.name != "" then user.name else user.email
      # Get initials from name
      _.map(name.split(' ', 2), (item) ->
        item[0].toUpperCase()
      ).join('')

  getNameAndStatus: (player) ->
    state = player.get('state').replace('_', ' ')
    `<div>
      {player.get('user').name}
      <strong>{state}</strong>
    </div>`

  render: ->
    # Can also use the .player--highlighted class to indicate "you"
    players = @props.players.map((player) =>
      user = player.get('user')
      highlighted = if window.Sembl.user?.email is user.email then " player--highlighted" else ""
      avatar = @getAvatar(user)
      nameAndStatus = @getNameAndStatus(player)

      `<li key={player.cid} className="game__player">
          <div className="game__player__details">
            <span className={"game__player__details__avatar" + highlighted}>
              {avatar}
            </span>
            <em>{nameAndStatus}</em>
            <span className="game__player__details__score">
              <i className="fa fa-star"></i>{player.formatted_score()}
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

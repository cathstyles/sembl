###* @jsx React.DOM ###

@Sembl.Games.Setup.StepPlayers = React.createClass
  componentWillMount: ->
    $(window).on('setup.players.give', @handleGivePlayers)

  componentWillUnmount: ->
    $(window).off('setup.players.give', @handleGivePlayers)

  componentDidMount: ->
    $(window).trigger('setup.players.get')

  getInitialState: ->
    players: null

  handleGivePlayers: (event, data) ->
    if data.players?
      @setState players: data.players

  handleDeletePlayer: (player) ->
    data =
      player: player
      success: @reloadPlayers
    event.preventDefault();
    $(window).trigger('setup.players.remove', data)

  handleInvite: (event) ->
    event.preventDefault()
    event.stopPropagation()
    input = @refs.emailInput.getDOMNode()
    email = input.value
    emailPattern = /\S+@\S+/
    if emailPattern.exec(email)
      input.value = ""
      input.focus()
      data =
        email: email
        success: =>
          @reloadPlayers()
      $(window).trigger('setup.players.add', data)
    else
      $(window).trigger('flash.error', 'invalid email address')

  isValid: ->
    true

  render: ->
    if @state.players?
      players = @state.players
      playerCount = players.length
      maxPlayerCount = @props.game.get('number_of_players')

      playerComponents = $.map(players, (player) =>
        user = player.get('user')
        email = if user then user.email else player.get('email')

        handleDelete = (event) => @handleDeletePlayer(player); event.preventDefault()
        `<div className="setup__steps__players__player--filled" key={player.id}>
          {email}
          <a className="setup__steps__players__remove-button" onClick={handleDelete} href="#"><i className="fa fa-times"></i></a>
        </div>`
      )


      inviteComponent = if playerCount < maxPlayerCount
        `<form className="setup__steps__players__invite" onSubmit={this.handleInvite}>
          <label htmlFor="setup__steps__players__invite__input" className="setup__steps__players__invite__label">Enter email address: </label>
          <input ref='emailInput' id="setup__steps__players__invite__input" className="setup__steps__players__invite__input" type="text" />
          <button className="setup__steps__players__invite__send-button" type="submit">Add</button>
        </form>`

      `<div className="setup__steps__players">
        <div className="setup__steps__title">
          {playerCount != 0 ? 'These players have been invited:' : 'No players have been invited. Invite some!'}
        </div>
        <div className="setup__steps__inner">
          <div>
            {playerComponents}
          </div>
          {inviteComponent}
        </div>
      </div>`
    else
      `<div className="setup__steps__players">
        <div className="setup__steps__inner">
          <p>Checking invited players&hellip;</p>
        </div>
      </div>`


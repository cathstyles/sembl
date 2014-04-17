###* @jsx React.DOM ###

@Sembl.Games.Setup.StepPlayers = React.createClass
  getInitialState: ->
    players: null

  handleAjaxError: (response) ->
    responseObj = JSON.parse(response.responseText)
    console.error responseObj
    if response.status == 422
      msgs = (value for key, value of responseObj.errors)
      $(window).trigger('flash.error', msgs.join(", "))   
    else
      $(window).trigger('flash.error', "Error: #{responseObj.errors}")

  componentWillMount: ->
    @loadInvitedPlayers()

  loadInvitedPlayers: ->
    $.ajax(
      url: "#{@props.game.url()}/players"
      dataType: 'json'
      type: 'GET'
      success: (data) =>
        @setState 
          players: new Sembl.Players(data.players)
      error: @handleAjaxError
    )

  handleDeletePlayer: (player) ->
    $.ajax(
      url: "#{@props.game.url()}/players/#{player.id}"
      dataType: 'json'
      type: 'DELETE'
      data:
        authenticity_token: this.props.game.get('auth_token')
      success: (data) =>
        console.log 'delete success', data
        $(window).trigger('flash.notice', data.message)
        @loadInvitedPlayers()
      error: @handleAjaxError
    )

  handleInvite: (event) ->
    email = @refs.emailInput.getDOMNode().value
    emailPattern = /\S+@\S+/
    if emailPattern.exec(email)
      @createPlayer(email)
    else
      $(window).trigger('flash.error', 'invalid email address')

  createPlayer: (email) ->
    game = @props.game

    url = "#{game.url()}/players"
    data =
      player:
        email: email
      authenticity_token: this.props.game.get('auth_token')
    $.ajax(
      url: url
      data: data
      type: 'POST'
      dataType: 'json'
      success: =>
        @refs.emailInput.getDOMNode().value = null
        @loadInvitedPlayers()
      error: @handleAjaxError
    )

  isValid: ->
    true

  render: ->
    if @state.players?
      players = @state.players.models
      playerCount = players.length
      maxPlayerCount = @props.game.get('number_of_players')

      playerComponents = $.map(players, (player) =>
        console.log 'player', player
        user = player.get('user')
        email = if user then user.email else player.get('email')

        handleDelete = (event) => @handleDeletePlayer(player); event.preventDefault()
        `<div className="setup__steps__players__player--filled" key={player.id}>
          {email}
          <button className="setup__steps__players__remove-button" onClick={handleDelete}>Remove</button>
        </div>`
      )


      inviteComponent = if playerCount < maxPlayerCount
        `<div className="setup__steps__players__invite">
          <label htmlFor="setup__steps__players__invite__input">Enter email address: </label>
          <input ref='emailInput' id="setup__steps__players__invite__input" type="text" />
          <button className="setup__steps__players__invite__send-button" onClick={this.handleInvite}>Add</button>
        </div>`

      `<div className="setup__steps__players">
        <div className="setup__steps__players__header">
          {playerCount != 0 ? 'These players have joined the game' : 'No players have joined the game. Add some!'}
        </div>
        <div>
          {playerComponents}
        </div>
        {inviteComponent}
      </div>`
    else 
      `<div className="setup__steps__players">
        <div>Checking invited players...</div>
      </div>`


###* @jsx React.DOM ###

@Sembl.Games.Setup.Players = React.createClass
  componentWillMount: ->
    $(window).on('setup.players.add', @handleAdd)
    $(window).on('setup.players.remove', @handleRemove)
    $(window).on('setup.players.get', @handleGet)
    @loadInvitedPlayers()

  componentWillUnmount: ->
    $(window).off('setup.players.add', @handleAdd)
    $(window).off('setup.players.remove', @handleRemove)
    $(window).off('setup.players.get', @handleGet)

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

  loadInvitedPlayers: (callback) ->
    $.ajax(
      url: "#{@props.game.url()}/players"
      dataType: 'json'
      type: 'GET'
      success: (data) =>
        @players = new Sembl.Players(data.players).models
        $(window).trigger('setup.players.give', {players: @players})
      error: @handleAjaxError
    )

  getPlayers: ->
    return @state.players

  handleGet: (event) ->
    $(window).trigger('setup.players.give', {players: @players})

  handleRemove: (event, data) ->
    player = data.player

    $.ajax(
      url: "#{@props.game.url()}/players/#{player.id}"
      dataType: 'json'
      type: 'DELETE'
      data:
        authenticity_token: this.props.game.get('auth_token')
      success: (data) =>
        $(window).trigger('flash.notice', data.message)
        @loadInvitedPlayers()
      error: @handleAjaxError
    )

  handleAdd: (event, data) ->
    email = data.email

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
      success: (data) =>
        @loadInvitedPlayers()

      error: @handleAjaxError
    )

  render: ->
    `<div/>`

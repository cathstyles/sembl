#= require views/components/tooltip

###* @jsx React.DOM ###

{classSet} = React.addons
{Tooltip} = @Sembl.Components
Sembl.Games.Gameboard.StatusView = React.createClass

  componentWillMount: ->
    state = @props.game.get('player')?.state
    if state is 'rating' then @handleContinueRating()

  handleEndTurn: ->
    @props.handleEndTurn()

  handleContinueRating: ->
    Sembl.router.navigate("rate", trigger: true)

  #TODO handle disabled state
  getButtonForStatus: (state, move_state) ->

    player = @props.game.get('player')

    disabled = false
    buttonAlertedClass = ""
    if state is 'playing_turn' and move_state is ""
      disabled = true if move_state == "open"
      buttonText = "End your turn"
      buttonClassExtra = "game__status__end-turn game__status__end-turn--soft"
      buttonAlertedClass = " alerted" if move_state is 'created'
      buttonIcon = "fa fa-clock-o"
      buttonClickHandler = @handleEndTurn
    else if state is 'playing_turn'
      disabled = true if move_state == "open"
      buttonText = "End your turn"
      buttonClassExtra = "game__status__end-turn"
      buttonAlertedClass = " alerted" if move_state is 'created'
      buttonIcon = "fa fa-clock-o"
      buttonClickHandler = @handleEndTurn
    else if state is 'waiting'
      disabled = true
      buttonText = "Waiting ..."
      buttonClassExtra = "game__status__waiting"
      buttonIcon = "fa fa-clock-o"
      buttonClickHandler = null
    else if state is 'rating'
      buttonText = "Continue Rating"
      buttonClassExtra = "game__status__rating"
      buttonIcon = "fa fa-thumbs-o-up"
      buttonClickHandler = @handleContinueRating

    buttonClassNames = classSet
      "game__status__button": true
      "button--disabled": disabled

    `<button
      className={buttonClassNames + " " + buttonClassExtra + " " + buttonAlertedClass}
      disabled={disabled}
      onClick={buttonClickHandler}>
        {<i className={buttonIcon}></i>}
        {buttonText}
    </button>`

  getTooltip: (state, move_state) ->
    round = @props.game.get('current_round')
    if state is 'playing_turn' and move_state is 'created'
      if round == 1
        tooltip = "On the board — nice work! End your turn to let  us know you’re finished."
      else if round == 2
        availableNodes = @nodesForUserState("available")
        tooltip = if availableNodes?.length > 0
          "Great! Now fill the other #{if availableNodes.length > 1 then availableNodes.length + ' nodes' else 'node'}"
        else
          "Hey, yay, all nodes are full. End your turn?"

  triggerNotice: ->
    player = @props.game.get('player')
    if player
      tooltipText = @getTooltip(player.state, player.move_state)
      $(window).trigger("flash.notice", tooltipText) if !!tooltipText

  handleJoin: (e) ->
    e?.preventDefault()
    if Sembl.user
      $(window).trigger('header.joinGame')
    else
      window.location = "/users/sign_in"

  componentDidUpdate: ->
    @triggerNotice()

  componentDidMount: ->
    @triggerNotice()

  nodesForUserState: (userState) ->
    @props.game.nodes.where(user_state: userState)

  render: ->
    player = @props.game.get('player')

    statusHTML = `<div className="game__status"/>`
    if player?
      if player.state is "playing_turn" && player.move_state is "open"
        statusButton = @getButtonForStatus(player.state, player.move_state)
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>Select an open position to create a Sembl.</p>
          </div>
        </div>`
      else if player.state is "playing_turn"
        availableNodes = @nodesForUserState("available")
        if availableNodes?.length > 0
          statusButton = @getButtonForStatus(player.state, "")
          statusText = "There are more nodes to fill, though you can end your turn early if you like."
        else
          statusButton = @getButtonForStatus(player.state, player.move_state)
          statusText = "End your turn to let us know when you’re done."
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>{statusText}</p>
            {statusButton}
          </div>
        </div>`
      else if player.state is "waiting" and @props.game.get('state') is "rating"
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>Too quick! We’re just waiting for everyone else to finish rating.</p>
          </div>
        </div>`
      else if player.state is "rating"
        statusButton = @getButtonForStatus(player.state, player.move_state)
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>Make sure you finish rating everyone’s Sembls</p>
            {statusButton}
          </div>
        </div>`
      else if player.state is "waiting"
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>We’re waiting for the other players to finish their turns, then you’ll get a chance to rate their Sembls.</p>
          </div>
        </div>`
      else if (@props.game.resultsAvailableForRound() && @props.game.get("is_participating")) && @props.game.get("state") is "completed"
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>Game over!</p>
            <a href={'#results/' + this.props.game.resultsAvailableForRound()} className="game__status__button game__status__end-turn">
              View the results
            </a>
          </div>
        </div>`
    else if @props.game.get("state") != "completed" && @_remainingPlayerCount() > 0
      statusHTML = `<div className="game__status">
        <div className="game__status-inner">
          <p>We need {this._formatPlayerCount()} to get started!</p>
          <a href="#join" onClick={this.handleJoin} className="game__status__button game__status__end-turn">Join this game</a>
        </div>
      </div>`
    else if @props.game.get("state") != "completed" && @_remainingPlayerCount() == 0
      statusHTML = `<div className="game__status">
        <div className="game__status-inner">
          <p>This game has a full complement of players.</p>
        </div>
      </div>`
    return statusHTML

  _remainingPlayerCount: ->
    @props.game.get("number_of_players") - @props.game.players.length

  _formatPlayerCount: ->
    remaining = @_remainingPlayerCount()
    "#{remaining} #{if @props.game.players.length > 0 then 'more' else ''} player#{if remaining > 0 then 's' else ''}"

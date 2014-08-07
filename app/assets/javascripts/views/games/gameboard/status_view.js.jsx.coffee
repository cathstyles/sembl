#= require views/components/tooltip

###* @jsx React.DOM ###

{classSet} = React.addons
{Tooltip} = @Sembl.Components
Sembl.Games.Gameboard.StatusView = React.createClass

  handleEndTurn: ->
    @props.handleEndTurn()

  handleContinueRating: ->
    Sembl.router.navigate("rate", trigger: true)

  #TODO handle disabled state
  getButtonForStatus: (state, move_state) ->

    player = @props.game.get('player')

    disabled = false
    buttonAlertedClass = ""
    if state is 'playing_turn'
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
        tooltip = "On the board — nice work!"
      else if round == 2
        tooltip = "If you have made all the moves you want to make, end your turn to let us know you are finished."

  triggerNotice: ->
    player = @props.game.get('player')
    if player
      tooltipText = @getTooltip(player.state, player.move_state)
      $(window).trigger("flash.notice", tooltipText) if !!tooltipText

  componentDidUpdate: ->
    @triggerNotice()

  componentDidMount: ->
    @triggerNotice()

  render: ->
    player = @props.game.get('player')

    console.log "PPPROPS", @props

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
        statusButton = @getButtonForStatus(player.state, player.move_state)
        statusHTML = `<div className="game__status">
          <div className="game__status-inner">
            <p>End your turn to let us know when you’re done.</p>
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
    return statusHTML

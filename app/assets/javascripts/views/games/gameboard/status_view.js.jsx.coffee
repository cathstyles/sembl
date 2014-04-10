#= require views/components/tooltip

###* @jsx React.DOM ###

{Tooltip} = @Sembl.Components
Sembl.Games.Gameboard.StatusView = React.createClass

  handleEndTurn: -> 
    @props.handleEndTurn()
      
  handleContinueRating: -> 
    Sembl.router.navigate("rate", trigger: true)

  #TODO handle disabled state
  getButtonForStatus: (state, move_state) -> 
    disabled = false
    if state is 'playing_turn'
      disabled = true if move_state == "open"
      buttonText = "End Turn"
      buttonClassName = "game__status__button game__status__end-turn"
      buttonIcon = "fa fa-clock-o"
      buttonClickHandler = @handleEndTurn
    else if state is 'waiting'
      disabled = true
      buttonText = "Waiting ..."
      buttonClassName = "game__status__button game__status__waiting button--disabled"
      buttonIcon = "fa fa-clock-o"
      buttonClickHandler = null
    else if state is 'rating'
      buttonText = "Continue Rating"
      buttonClassName = "game__status__button game__status__rating"
      buttonIcon = "fa fa-thumbs-o-up"
      buttonClickHandler = @handleContinueRating

    `<button 
      className={buttonClassName} 
      onClick={buttonClickHandler}>
        {<i className={buttonIcon}></i>}
        {buttonText}
    </button>`

  getTooltip: (state, move_state) -> 
    round = @props.game.get('current_round')

    if state is 'playing_turn' and move_state is 'created'
      if round == 1
        tooltip = "Are you happy with your move? End your turn to let us know you are finished."
      else if round == 2
        tooltip = "Have you made all of the moves you want to make? End your turn to let us know you are finished."
  
  render: -> 
    game_status = @props.game.get('status')
    player = @props.game.get('player')

    if player
      statusHTML = @getButtonForStatus(player.state, player.move_state)
    else
      statusHTML = game_status

    if player 
      tooltipText = @getTooltip(player.state, player.move_state)
      tooltip = if tooltipText
        `<Tooltip className="game__status__tooltip">{tooltipText}</Tooltip>`

    `<div className="game__status">
      {tooltip}
      {statusHTML}
    </div>`

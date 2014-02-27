###* @jsx React.DOM ###

Sembl.Games.Gameboard.StatusView = React.createClass

  handleEndTurn: -> 
    
    
  handleContinueRating: -> 

  getButtonForStatus: (state, move_state) -> 
    disabled = ""
    if state is 'playing_turn'
      disabled = "disabled" if move_state == "open"
      buttonText = "End Turn"
      buttonClassName = "game__status__end-turn"
      buttonClickHandler = @handleEndTurn
    else if state is 'waiting'
      disabled = "diabled"
      buttonText = "Waiting ..."
      buttonClassName = "game__status__waiting"
      buttonClickHandler = nil
    else if state is 'rating'
      buttonText = "Continue Rating"
      buttonClassName = "game__status__rating"
      buttonClickHandler = @handleContinueRating

    `<button 
      className={buttonClassName} 
      onClick={buttonClickHandler}
      disabled={disabled}>
        {buttonText}
    </button>`

  render: -> 
    game_status = @props.game.get('status')
    player = @props.game.get('player')

    if player
      statusHTML = @getButtonForStatus(player.state, player.move_state)
    else
      statusHTML = game_status

    return `<div className="game__status">
        {statusHTML}
      </div>`

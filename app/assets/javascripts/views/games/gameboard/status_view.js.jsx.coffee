###* @jsx React.DOM ###

Sembl.Games.Gameboard.StatusView = React.createClass

  handleEndTurn: -> 
    
  handleContinueRating: -> 

  getButtonForStatus(status): -> 
    
    if status is 'playing_turn'
      buttonText = "End Turn"
      buttonClassName = "game__status__end-turn"
      buttonClickHandler = @handleEndTurn
    else if status is 'waiting'
      buttonText = "Waiting ..."
      buttonClassName = "game__status__waiting"
      buttonClickHandler = nil
    else if status is 'rating'
      buttonText = "Continue Rating"
      buttonClassName = "game__status__rating"
      buttonClickHandler = @handleContinueRating

    return `<button className={buttonClassName} onClick={buttonClickHandler}>
      {buttonText}
    </button>`

  render: -> 
    game_status = @props.game.get('status')

    if player
      statusHTML = getButtonForStatus(player.get('status'))
    else
      statusHTML = game_status

    return `<div className="game__status">
        {statusHTML}
      </div>`

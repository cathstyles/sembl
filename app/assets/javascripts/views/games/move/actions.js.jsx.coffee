###* @jsx React.DOM ###

@Sembl.Games.Move.Actions = React.createClass
  
  handleSubmitMove: (event) ->
    $(window).trigger('move.actions.submitMove')
    event.preventDefault()

  render: () ->
    buttonClassName = "move__actions__button"
    if !@props.move.isValid()
      buttonClassName += " button--disabled"
      
    `<div className="move__actions">
      <button className={buttonClassName} onClick={this.handleSubmitMove}>
        <i className="fa fa-thumbs-up"></i> Submit move
      </button>
    </div>`

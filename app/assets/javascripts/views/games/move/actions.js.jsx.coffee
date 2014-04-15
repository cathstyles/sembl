###* @jsx React.DOM ###

@Sembl.Games.Move.Actions = React.createClass
  
  handleSubmitMove: (event) ->
    $(window).trigger('move.actions.submitMove')
    event.preventDefault()

  render: () ->
    `<div className="move__actions">
      <button className="move__actions__button" onClick={this.handleSubmitMove}>
        <i className="fa fa-thumbs-up"></i> Submit move
      </button>
    </div>`

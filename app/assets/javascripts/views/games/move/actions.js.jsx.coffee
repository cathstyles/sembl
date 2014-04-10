#= require views/components/tooltip

###* @jsx React.DOM ###

{Tooltip} = @Sembl.Components
@Sembl.Games.Move.Actions = React.createClass
  
  handleSubmitMove: (event) ->
    $(window).trigger('move.actions.submitMove')
    event.preventDefault()

  render: () ->
    `<div className="move__actions">
      <Tooltip className="move__actions__tooltip">
        Happy with your move? Submit to keep playing
      </Tooltip>
      <button className="move__actions__button" onClick={this.handleSubmitMove}>
        <i className="fa fa-thumbs-up"></i> Submit move
      </button>
    </div>`

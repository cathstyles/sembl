#= require views/games/move/upload_modal

###* @jsx React.DOM ###

{UploadModal} = Sembl.Games.Move

@Sembl.Games.Move.Actions = React.createClass
  handleUpload: (event) ->
    $(window).trigger('modal.open', `<UploadModal game={this.props.game} />`)

  handleSubmitMove: (event) ->
    $(window).trigger('move.actions.submitMove')
    event.preventDefault()

  render: () ->
    buttonClassName = "move__actions__button"
    if !@props.move.isValid()
      buttonClassName += " button--disabled"

    if @props.move.isValid()
      `<div className="move__actions">
        <div className="move__actions-inner">
          <p>Happy with your move? Submit it to keep playing.</p>
          <button className={buttonClassName} onClick={this.handleSubmitMove}>
            <i className="fa fa-thumbs-up"/> Submit move
          </button>
        </div>
      </div>`
    else if !@props.move.isValid() and @props.game.get('uploads_allowed')
      `<div className="move__actions">
        <div className="move__actions-inner">
          <button className="move__actions__button" onClick={this.handleUpload}>
            <i className="fa fa-thumbs-up"/> Upload or use custom image
          </button>
        </div>
      </div>`
    else
      `<div className="move__actions"/>`

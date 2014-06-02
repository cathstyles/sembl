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

    uploadButton = if @props.game.get('uploads_allowed')
      `<button className="move__actions__button" onClick={this.handleUpload}>
        <i className="fa fa-thumbs-up"></i> Upload image
      </button>`

    `<div className="move__actions">
      {uploadButton}

      <button className={buttonClassName} onClick={this.handleSubmitMove}>
        <i className="fa fa-thumbs-up"></i> Submit move
      </button>
    </div>`

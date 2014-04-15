###* @jsx React.DOM ###

@Sembl.Games.Setup.OverviewActions = React.createClass
  className: "setup__overview__actions"
  
  handleSave: ->
    $(window).trigger('setup.save')

  handlePublish: ->
    $(window).trigger('setup.publish')

  render: () ->
    isChanged = true
    isPublished = false
    isSaved = false

    saveButtonClassName="games-setup__actions__save__button" + if !isChanged then " button--disabled" else ""
    publishButtonClassName="games-setup__actions__publish__button"

    publishOrShowGame = if !isPublished
        `<div className="games-setup__actions__publish">
          <button className="games-setup__actions__publish__button" onClick={this.handlePublish}>
            <i className="fa fa-gamepad"></i> Publish
          </button>
        </div>`
      else
        `<div className="games-setup__actions__show">
          <a className="games-setup__actions__show__button" href={this.props.game.showUrl()}>
            <i className="fa fa-gamepad"></i> Go to game board
          </a>
        </div>`

    `<div className="games-setup__actions">
      <h3 className="games-setup__actions-status">Status: {this.props.status}</h3>
      <div className="games-setup__actions__save">
        <button className={saveButtonClassName} onClick={this.handleSave} disabled={!isChanged}>
            {isSaved ? "Saved" : "Save"}
        </button>
      </div>
      {publishOrShowGame}
    </div>`
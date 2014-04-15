###* @jsx React.DOM ###

@Sembl.Games.Setup.OverviewActions = React.createClass
  className: "setup__overview__actions"
  
  handleSave: (event) ->
    $(window).trigger('setup.save')
    event.preventDefault();

  handlePublish: (event) ->
    $(window).trigger('setup.publish')
    event.preventDefault();

  handleOpenGame: (event) ->
    $(window).trigger('setup.openGame')
    event.preventDefault();

  render: () ->
    isChanged = true
    isPublished = @props.status? && @props.status != 'draft'
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
          <a className="games-setup__actions__show__button" onClick={this.handleOpenGame}>
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
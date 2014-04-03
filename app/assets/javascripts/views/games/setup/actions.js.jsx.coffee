###* @jsx React.DOM ###

@Sembl.Games.Setup.Actions = React.createClass
  className: "games-setup__actions"
  
  componentWillMount: ->
    $(window).on('setup.game.change', @handleChange)
    $(window).on('setup.game.saved', @handleSaved)

  componentWillUnmount: ->
    $(window).off('setup.game.change')
    $(window).off('setup.game.saved')

  getInitialState: ->
    changed: false

  handleChange: ->
    @setState
      changed: true

  handleSave: ->
    $(window).trigger('setup.game.save')

  handleSaved: ->
    @setState
      changed: false
  
  handlePublish: ->
    $(window).trigger('setup.game.publish')

  render: () ->
    isChanged = @state.changed
    isSaved = !@state.changed and @props.status != 'new'
    isPublished = @props.status not in ['new', 'draft']
    
    saveButtonClassName="#{@className}__save__button" + if !isChanged then " button--disabled" else ""
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
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

    `<div className="games-setup__actions">
      <h3 className="games-setup__actions-status">Status: {this.props.status}</h3>
      <div className="games-setup__actions-save">
        <button className="games-setup__actions-save__button" onClick={this.handleSave}
            disabled={!isChanged}>
            {isSaved ? "Saved" : "Save"}
            {isChanged ? '*' : ''}
        </button>
      </div>
      <div className="games-setup__actions-publish">
        <button className="games-setup__actions-publish__button" onClick={this.handlePublish}
          disabled={isPublished}>
          <i className="fa fa-gamepad"></i> {isPublished ? "Published" : "Publish"} 
        </button>
      </div>
    </div>`
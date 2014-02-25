###* @jsx React.DOM ###

@Sembl.Games.Setup.Actions = React.createClass
  className: "games-setup__actions"
  render: () ->
    `<div className="games-setup__actions">
      <h3 className="games-setup__actions-status">Status: Saved</h3>
      <div className="games-setup__actions-inner">
        <button>Clone another game</button>
        <button onClick={this.handleSave}>Save</button>
      </div>
      <div className="games-setup__actions-publish">
        <button className="games-setup__actions-publish__button" onClick={this.handlePublish}>Publish</button>
      </div>
    </div>`
###* @jsx React.DOM ###

@Sembl.Games.Setup.Actions = React.createClass
  className: "games-setup__actions"

  render: () ->
    handleSave = this.props.requests.requestSave
    handlePublish = this.props.requests.requestPublish
    `<div className="games-setup__actions">
      <h3 className="games-setup__actions-status">Status: Saved</h3>
      <div className="games-setup__actions-inner">
        <ul className="games-setup__actions-list">
          <li className="games-setup__actions-list-item">
            <a href="#" className="games-setup__actions-list-anchor">Clone another game</a>
          </li>
          <li className="games-setup__actions-list-item">
            <a href="#" onClick={handleSave} className="games-setup__actions-list-anchor">Save Game</a>
          </li>
        </ul>
      </div>
      <div className="games-setup__actions-publish">
        <button className="games-setup__actions-publish__button" onClick={handlePublish}>
          <i className="fa fa-gamepad"></i> Publish
        </button>
      </div>
    </div>`
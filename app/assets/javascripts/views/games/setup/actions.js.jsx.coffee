###* @jsx React.DOM ###

@Sembl.Games.Setup.Actions = React.createClass
  className: "games-setup__actions"
  render: () ->
    `<div className={this.className}>
      <p>Status</p>
      <ul>
        <li>Clone another game</li>
        <li>Save current settings</li>
      </ul>
      <button>start game</button>
    </div>`
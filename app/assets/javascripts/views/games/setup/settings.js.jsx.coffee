###* @jsx React.DOM ###

@Sembl.Games.Setup.SettingsCheckbox = React.createClass
  getInitialState: () ->
    tmp = 
      checked: if this.props.value then true else false
      value: if this.props.value then 1 else 0
    tmp


  handleChange: (event) ->
    this.setState 
      checked: event.target.checked
      value: if event.target.checked then 1 else 0
    true

  render: () ->
    className = "games-setup__settings__" + this.props.ref
    inputId = className + "__input"

    `<div className={this.className}>
      <div className="games-setup__settings-item">
        <input type="hidden" value={this.state.value} />
        <input id={inputId} type="checkbox" checked={this.state.checked} onChange={this.handleChange} />
        <label className="boolean optional control-label" htmlFor={inputId}>{this.props.label}</label>
      </div>
    </div>`

{SettingsCheckbox} = @Sembl.Games.Setup
@Sembl.Games.Setup.Settings = React.createClass
  getParams: () ->
    invite_only:          this.refs.invite_only.state.value
    allow_keyword_search: this.refs.allow_keyword_search.state.value
    mature_allowed:       this.refs.mature_allowed.state.value
    uploads_allow:        this.refs.uploads_allow.state.value

  className: "games-setup__settings"
  render: () ->
    `<div className={this.className}>
      <h3 className="games-setup__settings-title">Settings</h3>
      <SettingsCheckbox 
        ref="invite_only" 
        value={this.props.invite_only}
        label="Game is invite only" />
      <SettingsCheckbox 
        ref="allow_keyword_search"
        value={this.props.allow_keyword_search}
        label="Allow keyword search" />
      <SettingsCheckbox 
        ref="mature_allowed" 
        value={this.props.mature_allowed}
        label="Show mature images"/>
      <SettingsCheckbox 
        ref="uploads_allow" 
        value={this.props.uploads_allowed}
        label="Users can upload images"/>
    </div>`

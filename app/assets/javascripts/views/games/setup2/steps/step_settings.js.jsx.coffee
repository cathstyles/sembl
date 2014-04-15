###* @jsx React.DOM ###

@Sembl.Games.Setup.SettingsCheckbox = React.createClass
  handleChange: (event) ->
    @props.handleChange(@props.name, event.target.checked)

  render: () ->
    checked = this.props.checked || false
    className = "setup__steps__settings__#{@props.name}"
    inputId = "#{className}__input"

    `<div className={className}>
      <div className="games-setup__settings-item">
        <input id={inputId} type="checkbox" checked={checked} onChange={this.handleChange} />
        <label className="boolean optional control-label" htmlFor={inputId}>{this.props.label}</label>
      </div>
    </div>`

{SettingsCheckbox} = @Sembl.Games.Setup
@Sembl.Games.Setup.StepSettings = React.createClass
  handleChange: (setting, value) ->
    settings =
      invite_only:    this.props.settings?.invite_only || false
      mature_allowed: this.props.settings?.mature_allowed || false
      uploads_allowed:  this.props.settings?.uploads_allowed || false

    settings[setting] = value
    $(window).trigger('setup.steps.change', {settings: settings})

  render: () ->
    if this.props.settings?
      {invite_only, mature_allowed, uploads_allowed} = this.props.settings 

    `<div className="setup__steps__settings">
      <h3>Settings</h3>
      <SettingsCheckbox name='invite_only' checked={invite_only} label="Game is invite only" handleChange={this.handleChange} />
      <SettingsCheckbox name='mature_allowed' checked={mature_allowed} label="Show mature images" handleChange={this.handleChange} />
      <SettingsCheckbox name='uploads_allowed' checked={uploads_allowed} label="Users can upload images" handleChange={this.handleChange} />
    </div>`

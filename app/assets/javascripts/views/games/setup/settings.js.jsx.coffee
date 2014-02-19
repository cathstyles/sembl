###* @jsx React.DOM ###

@Sembl.Games.Setup.SettingsCheckbox = React.createClass
  className: "games-setup__settings-checkbox"

  getInitialState: () ->
    if (this.props.input)
      checked: this.props.input.value == 1 ? true : false
    else
      checked: false

  handleChange: (event) ->
    this.setState 
      checked: event.target.checked
    true

  render: () ->
    input = this.props.input || {}
    label = this.props.label
    checked = this.state.checked
    input_name = input.name
    id = this.className + "__" + input_name

    `<div className={this.className}>
      <input type="hidden" name={input_name} value={checked ? 1 : 0} />
      <input id={id} type="checkbox" checked={checked} onChange={this.handleChange} />
      <label className="boolean optional control-label" htmlFor={id}>{label}</label>
    </div>`

{SettingsCheckbox} = @Sembl.Games.Setup
@Sembl.Games.Setup.Settings = React.createClass
  className: "games-setup__settings"
  render: () ->
    `<div className={this.className}>
      <p>SETTINGS</p>
      <SettingsCheckbox input={this.props.invite_only}
        label="Game is invite only" />
      <SettingsCheckbox input={this.props.allow_keyword_search}
        label="Allow keyword search" />
      <SettingsCheckbox input={this.props.mature_allowed}
        label="Show mature images"/>
      <SettingsCheckbox input={this.props.uploads_allowed}
        label="Users can upload images"/>
    </div>`

#= require views/components/autofocus_input.js.jsx.coffee
#= require views/components/toggle_component.js.jsx.coffee
#= require views/components/display_text.js.jsx.coffee
#= require views/components/text_input.js.jsx.coffee
#= require views/components/textarea.js.jsx.coffee

###* @jsx React.DOM ###

{DisplayText, TextInput, Textarea, AutofocusTextInput, AutofocusTextarea, ToggleComponent} = @Sembl.Components
@Sembl.Games.Setup.Metadata = React.createClass
  className: "games-setup__metadata"

  getInitialState: () ->
    title: this.props.title
    description: this.props.description

  handleEditToggle: (event) ->
    if this.refs.title.state.toggle
      this.refs.title.handleToggleOff()
      this.refs.description.handleToggleOff()
    else
      this.refs.title.handleToggleOn()
      this.refs.description.handleToggleOn()
    event.preventDefault()

  handleNewTitle: (newValue) ->
    this.setState
      title: newValue

  handleNewDescription: (newValue) ->
    this.setState
      description: newValue

  render: () ->

    editableTitle = ToggleComponent
      ref: "title"
      toggle: this.state.edit
      OffClass: DisplayText
      OnClass: TextInput
      onProps:
        className: this.className + "__title-input"
        value: this.state.title
        requestChange: this.handleNewTitle
        autofocus: true
      offProps:
        className: this.className + "__title"
        value: this.state.title

    editableDescription = ToggleComponent
      ref: "description"
      OffClass: DisplayText
      OnClass: Textarea
      offProps:
        className: this.className + "__description"
        value: this.state.description
      onProps:
        className: this.className + "__description-textarea"
        value: this.state.description
        requestChange: this.handleNewDescription

    `<div className={this.className}>
      <span className="games-setup__metadata-edit" onClick={this.handleEditToggle}>Edit <i className="fa fa-edit"></i></span>
      {editableTitle}
      {editableDescription}
    </div>`
    

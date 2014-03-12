#= require views/components/toggle_component.js.jsx.coffee

###* @jsx React.DOM ###

autofocus_input = React.createClass 
  componentDidMount: ->
    @getDOMNode().focus()
  render: ->
    `<input type="text"
        className={this.props.className}
        value={this.props.value}
        onChange={this.props.onChange} />`

@Sembl.Games.Setup.Title = React.createClass
  handleChange: (event) ->
    @setState
      title: event.target.value

  getInitialState: ->
    title: @props.title
 
  render: ->
    ToggleComponent
      OffClass: `<div className="games-setup__metadata__title">{this.state.title}</div>`
      OnClass: `<autofocus_input className="games-setup__metadata__title-input"
        value={this.state.title} onChange={this.handleChange}/>`
      toggleEvent: 'toggle.setup.title.edit'

@Sembl.Games.Setup.Description = React.createClass
  handleChange: (event) ->
    @setState
      description: event.target.value

  getInitialState: ->
    description: @props.description
 
  render: ->
    ToggleComponent
      OffClass: `<div className="games-setup__metadata__description">{this.state.description}</div>`
      OnClass: `<textarea className="games-setup__metadata__description-textarea"
        value={this.state.description} onChange={this.handleChange}/>`
      toggleEvent: 'toggle.setup.description.edit'


{DisplayText, TextInput, Textarea, AutofocusTextInput, AutofocusTextarea, ToggleComponent} = @Sembl.Components
{Title, Description} = @Sembl.Games.Setup
@Sembl.Games.Setup.Metadata = React.createClass
  className: "games-setup__metadata"

  handleEditToggle: (event) ->
    $(window).trigger('toggle.setup.title.edit')
    $(window).trigger('toggle.setup.description.edit')

  getParams: ->
    title: @refs.title.state.title
    description: @refs.description.state.description

  render: () ->
    `<div className={this.className}>
      <span className="games-setup__metadata-edit" onClick={this.handleEditToggle}>Edit <i className="fa fa-edit"></i></span>
      <Title ref="title" title={this.props.title} />
      <Description ref="description" description={this.props.description} />
    </div>`
    

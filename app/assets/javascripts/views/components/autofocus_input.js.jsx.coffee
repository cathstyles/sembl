###* @jsx React.DOM ###

@Sembl.Components.AutofocusTextarea = React.createClass 
  componentDidMount: (rootNode) ->
    rootNode.focus()
    rootNode.select()
  
  render: () ->
    `<textarea
      value={this.props.value} 
      onChange={this.props.onChange}
      onBlur={this.props.onBlur} />`

@Sembl.Components.AutofocusTextInput = React.createClass 
  componentDidMount: (rootNode) ->
    rootNode.focus()

  render: () ->
    `<input type="text"
      value={this.props.value} 
      onChange={this.props.onChange}
      onBlur={this.props.onBlur} />`
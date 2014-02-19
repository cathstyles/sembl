###* @jsx React.DOM ###

@Sembl.Components.Textarea = React.createClass 
  componentDidMount: (rootNode) ->
    if this.props.autofocus
      rootNode.focus()

  handleChange: (event) ->
    if this.props.requestChange != undefined
      this.props.requestChange(event.target.value)
    event.preventDefault()
    
  render: () ->
    `<textarea className={this.props.className} 
      value={this.props.value}
      onChange={this.handleChange}>
    </textarea>`


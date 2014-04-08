###* @jsx React.DOM ###

@Sembl.Games.Setup.Meta = React.createClass
  getInitialState: ->
    console.log 'props', @props
    title: @props?.title
    description: @props?.description

  handleChange: (event) ->
    state = 
      title: @refs.title.getDOMNode().value
      description: @refs.description.getDOMNode().value
    @setState(state)
    $.doTimeout('debounce.setup.steps.change', 200, @bubbleChange, state)


  bubbleChange: (state) ->
    valid = !!state.title
    $(window).trigger('setup.steps.change', {properties: state, valid: valid})
    console.log valid, state

  render: ->
    `<div>
      <input ref="title" onChange={this.handleChange} value={this.state.title} />
      <input ref="description" onChange={this.handleChange} value={this.state.description} />
    </div>`

###* @jsx React.DOM ###

@Sembl.Games.Setup.Steps = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.change', @handleChange)

  componentWillUnmount: ->
    $(window).off('setup.steps.change')
    
  getInitialState: ->
    step: 0
    valid: if typeof(@props.steps[0]) == "function" then false else !@props.steps[0].props.validate
    properties: {}

  handleNext: ->
    @setState
      step: Math.min(@state.step + 1, @props.steps.length - 1)

  handlePrevious: ->
    @setState
      step: Math.max(@state.step - 1, 0)

  handleChange: (event, data) ->
    @setState(_.pick(data, 'valid', 'properties'))

  render: ->
    steps = @props.steps

    if @state.step < steps.length
      step = steps[@state.step]
      if typeof(step) == "function"
        step = step(@state.properties)

    isLast = @state.step == steps.length - 1

    previous = `<button onClick={this.handlePrevious}>Back</button>`
    next = `<button onClick={this.handleNext} disabled={!this.state.valid}>Next</button>`
    done = `<button disabled={!this.state.valid}>Done</button>`

    `<div className="setup__steps">
      {step}
      {this.state.step > 0 ? previous : null}
      {!isLast ? next :  done}
    </div>`
    
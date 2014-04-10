###* @jsx React.DOM ###

###
  Component for stepping through other components with next, back and done buttons.
  if a step has a 'validate' properties set to true then the next/done buttons are disabled 
  until a setup.steps.change event occurs with {valid: true} in the data.

  Each step can aggregate any changes by sending a setup.steps.change event with {properties: ...}
  These properties will passed back into the step (and other steps), using this.props. Thus state is
  managed by the Steps component not the individual steps.

  When all steps a done, a setup.steps.done event is triggered and passed any data collected.
###
@Sembl.Games.Setup.Steps = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.change', @handleChange)

  componentWillUnmount: ->
    $(window).off('setup.steps.change')

  getInitialState: ->
    step: 0
    valid: !@props.steps[0].props.validate
    properties: {}

  handleNext: ->
    @setState
      step: Math.min(@state.step + 1, @props.steps.length - 1)

  handlePrevious: ->
    @setState
      step: Math.max(@state.step - 1, 0)

  handleDone: ->
    console.log 'props', @state.properties
    $(window).trigger('setup.steps.done', @state.properties)

  handleChange: (event, data) ->
    state = @state
    if data.properties
      _.extend(state.properties, data.properties)
    if data.valid?
      state.valid = data.valid
    @setState(state)

  render: ->
    steps = @props.steps

    if @state.step < steps.length
      step = steps[@state.step]
      # If you want your subcomponent to have access to the collected properties 
      # then you need to pass in the component's class instead of the component
      if React.isValidClass(step)
        step = step(@state.properties)
      else if React.isValidComponent(step)
        step = React.addons.cloneWithProps(step, @state.properties)
      else 
        throw "invalid step, must be react class or component"

    isLast = @state.step == steps.length - 1

    previous = `<button className="setup__steps__actions__previous" onClick={this.handlePrevious}>Back</button>`
    next = `<button className="setup__steps__actions__next" onClick={this.handleNext} disabled={!this.state.valid}>Next</button>`
    done = `<button className="setup__steps__actions__done" onClick={this.handleDone} disabled={!this.state.valid}>Done</button>`

    `<div className="setup__steps">
      {step}
      <div className="setup__steps__actions">
        {this.state.step > 0 ? previous : null}
        {!isLast ? next :  done}
      </div>
    </div>`
    
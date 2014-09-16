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
    $(window).on('setup.steps.next', @handleNext)

  componentWillUnmount: ->
    $(window).off('setup.steps.change', @handleChange)
    $(window).off('setup.steps.next', @handleNext)

  componentDidMount: ->
    @validateStep()

  componentDidUpdate: ->
    @validateStep()

  getInitialState: ->
    step: 0
    collectedFields: @props.collectedFields || {}
    valid: false

  validateStep: ->
    valid = if @refs.currentStep.isValid? then @refs.currentStep.isValid() else true
    if valid != @state.valid
      @setState({valid:valid})

  handleNext: (e) ->
    e.preventDefault()
    @setState
      step: Math.min(@state.step + 1, @props.steps.length - 1)

  handlePrevious: (e) ->
    e.preventDefault()
    @setState
      step: Math.max(@state.step - 1, 0)

  handleDone: (e) ->
    e.preventDefault()
    $(window).trigger('setup.steps.done', @state.collectedFields)

  handleChange: (event, data) ->
    _.extend(@state.collectedFields, data)
    @setState(@state)

  render: ->
    steps = @props.steps

    if @state.step < steps.length
      isValid = @state.valid

      childProperties = _.extend({ref: 'currentStep'}, @state.collectedFields)
      step = steps[@state.step]
      if React.isValidClass(step)
        step = step(childProperties)
      else if React.isValidComponent(step)
        step = React.addons.cloneWithProps(step, childProperties)
      else
        err = {message: "invalid step, must be react class or component", step: step}
        console.error err
        throw err.message

    isLast = @state.step == steps.length - 1

    actionClassName = (action, disabled) ->
      className = "setup__steps__actions__#{action}"
      className += " button--disabled" if disabled
      className

    previous = `<button className={actionClassName('previous')} onClick={this.handlePrevious}><i className="fa fa-chevron-left"></i>&nbsp;Back</button>`
    next = `<button className={actionClassName('next', !isValid)} onClick={this.handleNext}>Next&nbsp;<i className="fa fa-chevron-right"></i></button>`
    done = `<button className={actionClassName('done', !isValid)} onClick={this.handleDone}>Done!</button>`
    formAction = if !isLast then @handleNext else @handleDone

    `<form className="setup__steps" onSubmit={formAction}>
      {step}
      <div className="setup__steps__actions">
        {this.state.step > 0 ? previous : null}
        {!isLast ? next :  done}
      </div>
    </form>`

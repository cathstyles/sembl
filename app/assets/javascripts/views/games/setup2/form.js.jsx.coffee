#= require views/games/setup2/overview/overview
#= require views/games/setup2/steps/steps
#= require views/games/setup2/steps/step_board
#= require views/games/setup2/steps/step_filter
#= require views/games/setup2/steps/step_seed
#= require views/games/setup2/steps/step_title

###* @jsx React.DOM ###

{Overview, Steps, StepBoard, StepFilter, StepSeed, StepTitle} = Sembl.Games.Setup
@Sembl.Games.Setup.Form = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.done', @handleStepsDone)
    $(window).on('setup.steps.add', @handleAddStep)
    $(window).on('setup.save', @handleSave)

    boards = @props.game.boards.sortBy('title')
    @stepComponents =
      title: `<StepTitle />`
      board: `<StepBoard boards={boards} />`
      seed: `<StepSeed />`
      filter: `<StepFilter />`

  componentWillUnmount: ->
    $(window).off('setup.steps.done') 
    $(window).off('setup.save') 

  getInitialState: ->
    activeSteps: @props.firstSteps || []
    collectedFields: _.extend({}, @props.formFields)

  getGameParams: (publish) ->
    params =
      game:
        board_id:      @state.collectedFields.board?.id
        seed_thing_id: @state.collectedFields.seed?.id
        title:         @state.collectedFields.title
        description:   @state.collectedFields.description
      authenticity_token: this.props.game.get('auth_token')

    # TODO add settings, sensitive, invite-only, etc
    # TODO add filter for power users
    # if @props.user.power
      # params.filter_content_by = @state.collectedFields.filter
    params

  handleSave: ->
    @createGame(@getGameParams())

  # TODO: handlePublish

  updateGame: (params) ->
    params._method = "patch"
    @createGame(params)

  createGame: (params) ->
    self = this
    url = "#{@props.game.url()}.json"
    $.ajax(
      url: url
      data: params
      type: 'POST'
      dataType: 'json'
      success: (data) =>
        console.log "saved game", data
        # TODO: redirect to Edit game
        Sembl.game = new Sembl.Game(data);
        @setState
          game: Sembl.game
      error: (response) =>
        console.log 'error', response
        responseObj = JSON.parse(response.responseText)
        console.log responseObj
        if response.status == 422 
          msgs = (value for key, value of responseObj.errors)
          $(window).trigger('flash.error', msgs.join(", "))   
        else
          $(window).trigger('flash.error', "Error: #{responseObj.errors}")
    )

  handleStepsDone: (event, collectedFields) ->
    @setState
      activeSteps: []
      collectedFields: _.extend(@state.collectedFields, collectedFields)

  handleAddStep: (event, data) ->
    if !data.stepName
      throw "cannot add step: #{data}"
    @state.activeSteps.push(data.stepName)
    @setState
      activeSteps: @state.activeSteps

  render: ->
    console.log 'new_view.state', @state
    boards = @props.game.boards.sortBy('title')
    stepList = []
    for step in @state.activeSteps
      stepList.push(@stepComponents[step])

    if stepList.length > 0
      show = `<Steps steps={stepList} doneEvent="setup.steps.done" collectedFields={this.state.collectedFields} />`
    else
      show = Overview(@state.collectedFields)

    `<div className="setup">
      {show}
    </div>`


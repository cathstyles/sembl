#= require views/games/setup2/overview
#= require views/games/setup2/steps/steps
#= require views/games/setup2/steps/step_title
#= require views/games/setup2/steps/step_board
#= require views/games/setup2/steps/step_seed

###* @jsx React.DOM ###

{Overview, StepTitle, StepBoard, StepSeed, Steps} = Sembl.Games.Setup
@Sembl.Games.Setup.New = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.done', @handleStepsDone)
    $(window).on('setup.steps.add', @handleAddStep)

    boards = @props.game.boards.sortBy('title')
    @stepComponents =
      title: `<StepTitle />`
      board: `<StepBoard boards={boards} />`
      seed: `<StepSeed />`

  componentWillUnmount: ->
    $(window).off('setup.steps.done') 

  getInitialState: ->
    activeSteps: ['board','title','seed']
    collectedFields: {}

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

@Sembl.views.setupNew = ($el, el) ->
  Sembl.game = new Sembl.Game($el.data().game);

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setState 
    body: Sembl.Games.Setup.New(game: Sembl.game, user: Sembl.user),
    header: Sembl.Games.HeaderView(model: Sembl.game, title: "New Game") 


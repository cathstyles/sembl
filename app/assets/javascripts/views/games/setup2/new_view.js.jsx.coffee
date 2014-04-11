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

  componentWillUnmount: ->
    $(window).off('setup.steps.done') 

  getInitialState: ->
    showSteps: true
    properties: {}

  handleStepsDone: (event, properties) ->
    @setState
      showSteps: false
      properties: properties

  render: ->
    boards = @props.game.boards.sortBy('title')
    stepList = [
      `<StepTitle validate={false} />`,
      `<StepBoard validate={false} boards={boards} />`,
      `<StepSeed validate={false} />`
    ]
    steps = `<Steps steps={stepList} doneEvent="setup.steps.done" />`
    overview = Overview(@state.properties)

    `<div className="setup">
        {this.state.showSteps ? steps : overview}
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


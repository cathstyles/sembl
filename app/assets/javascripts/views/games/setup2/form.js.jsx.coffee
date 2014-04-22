#= require views/components/searcher
#= require views/games/setup2/overview/overview
#= require views/games/setup2/steps/steps
#= require views/games/setup2/steps/step_board
#= require views/games/setup2/steps/step_description
#= require views/games/setup2/steps/step_filter
#= require views/games/setup2/steps/step_seed
#= require views/games/setup2/steps/step_settings
#= require views/games/setup2/steps/step_title
#= require views/games/setup2/steps/step_players
#= require views/games/setup2/players

###* @jsx React.DOM ###

{Searcher} = Sembl.Components
{Overview, Steps, Players} = Sembl.Games.Setup
{StepBoard, StepDescription, StepFilter, StepSeed, StepSettings, StepTitle, StepPlayers} = Sembl.Games.Setup
@Sembl.Games.Setup.Form = React.createClass
  filterSearcherPrefix: "setup.steps.filter.searcher"

  componentWillMount: ->
    $(window).on('setup.steps.done', @handleStepsDone)
    $(window).on('setup.steps.add', @handleAddStep)
    $(window).on('setup.save', @handleSave)
    $(window).on('setup.publish', @handlePublish)
    $(window).on('setup.openGame', @handleOpenGame)

    boards = @props.game.boards.sortBy('title')
    @stepComponents =
      board: `<StepBoard boards={boards} />`
      title: `<StepTitle />`
      seed: `<StepSeed />`
      description: `<StepDescription />`
      filter: `<StepFilter searcherPrefix={this.filterSearcherPrefix} />`
      settings: `<StepSettings />`
      players: `<StepPlayers game={this.props.game} />`

  componentWillUnmount: ->
    $(window).off('setup.steps.done') 
    $(window).off('setup.steps.add') 
    $(window).off('setup.save')
    $(window).off('setup.publish')
    $(window).off('setup.openGame')

  componentDidMount: ->
    seed = @state.collectedFields.seed
    if seed?.id
      $.getJSON("/api/things/#{seed.id}.json", {}, (thing) =>
        @setState 
          collectedFields: _.extend(@state.collectedFields, {seed: thing})
      )

  getInitialState: ->
    game = @props.game
    formFields = 
      title: game.get('title')
      description: game.get('description')
      seed: {id: game.get('seed_thing_id')}
      board: game.board
      filter: game.get('filter')
      settings:
        uploads_allowed: game.get('uploads_allowed')
        invite_only: game.get('invite_only')

    console.log 'formFields', formFields

    return state = 
      game: game
      activeSteps: @props.firstSteps || []
      collectedFields: formFields

  getGameParams: (publish) ->
    params =
      game:
        board_id:      @state.collectedFields.board?.id
        seed_thing_id: @state.collectedFields.seed?.id
        title:         @state.collectedFields.title
        description:   @state.collectedFields.description
        invite_only:     if @state.collectedFields.settings?.invite_only then 1 else 0
        mature_allowed:  if @state.collectedFields.settings?.mature_allowed then 1 else 0
        uploads_allowed: if @state.collectedFields.settings?.uploads_allowed then 1 else 0
      authenticity_token: this.props.game.get('auth_token')
    # TODO add filter for power users
    # if @props.user.power
      # params.filter_content_by = @state.collectedFields.filter
    params

  handleSave: ->
    params = @getGameParams()
    if @props.game.id
      @updateGame(params)
    else 
      @createGame(params)

  handlePublish: ->
    params = @getGameParams()
    params.publish = true
    if @props.game.id
      @updateGame(params)
    else 
      @createGame(params)

  handleOpenGame: ->
    if @props.game.id
      window.location = @props.game.showUrl()

  updateGame: (params) ->
    params._method = "patch"
    @postGame(params)

  createGame: (params) ->
    success = (data) => 
      url = new Sembl.Game(data).showUrl() + '/edit'
      window.location = url
    @postGame(params, success)

  postGame: (data, success, error) ->
    _success = (data) =>
      Sembl.game = new Sembl.Game(data)
      @setState
        game: Sembl.game
      console.log 'saved'
      success(data) if success?
    _error = (response) =>
      responseObj = JSON.parse(response.responseText)
      console.log responseObj
      if response.status == 422 
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))   
      else
        $(window).trigger('flash.error', "Error: #{responseObj.errors}")
      error(response) if error?
    url = "#{@props.game.url()}.json"
    $.ajax(
      url: url
      data: data
      type: 'POST'
      dataType: 'json'
      success: _success
      error: _error
    )

  handleStepsDone: (event, collectedFields) ->
    if !@props.game.id
      @handleSave()
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
    boards = @state.game.boards.sortBy('title')
    stepList = []
    for step in @state.activeSteps
      stepList.push(@stepComponents[step])

    if stepList.length > 0
      show = `<Steps steps={stepList} doneEvent="setup.steps.done" collectedFields={this.state.collectedFields} />`
    else
      overviewProps = _.extend({
          status: @state.game.get('state')
          invitedPlayers: @state.invitedPlayers
        }, @state.collectedFields)
      show = Overview(overviewProps)

    filter = @props.game.get('filter')
    `<div className="setup">
      {show}
      <Searcher filter={filter} prefix={this.filterSearcherPrefix} />
      <Players game={this.props.game} />
    </div>`



#= require views/games/setup/actions
#= require views/games/setup/metadata
#= require views/games/setup/seed
#= require views/games/setup/board
#= require views/games/setup/players
#= require views/games/setup/settings
#= require views/games/setup/candidates
#= require views/games/gallery
#= require views/layouts/default

###* @jsx React.DOM ###

{Actions, Board, Candidates, CandidatesGalleryModal, Filter, Metadata, Players, Seed, Settings} = @Sembl.Games.Setup
{Gallery} = @Sembl.Games
{Searcher} = Sembl.Components

@Sembl.Games.Setup.Root = React.createClass
  className: "games__setup"

  getInitialState: ->
    game: @props.game

  componentWillMount: () ->
    $(window).on('setup.game.save', @handleGameSave)
    $(window).on('setup.game.publish', @handleGamePublish)

  componentWillUnmount: () ->
    $(window).off('setup.game.save')
    $(window).off('setup.game.publish')

  getGameParams: (publish) ->
    params =
      game:
        board_id:      this.refs.board.state.id
        seed_thing_id: this.refs.seed.state.id
      authenticity_token: this.props.game.get('auth_token')
    _.extend(params.game, this.refs.settings.getParams())
    _.extend(params.game, this.refs.metadata.getParams())
    if @props.user.power
      # TODO this should come from the contributions component 
      params.filter_content_by = this.refs.filter.state.filter
    params

  handleGameSave: () ->
    console.log 'handle save'
    this.updateGame(this.getGameParams())

  handleGamePublish: () ->
    params = this.getGameParams()
    params.publish = true
    this.updateGame(params)

  updateGame: (params) ->
    self = this
    if this.state.game.id
      params._method = "patch"
    url = "#{@props.game.url()}.json"
    $.ajax(
      url: url
      data: params
      type: 'POST'
      dataType: 'json'
      success: (data) =>
        console.log "saved game", data
        Sembl.game = new Sembl.Game(data);
        @setState
          game: Sembl.game
        $(window).trigger('setup.game.saved')
      error: (response) =>
        console.log 'error', response
        try responseObj = JSON.parse(response.responseText)
        catch err then console.log err

        if response.status == 422 
          msgs = (value for key, value of responseObj.errors)
          $(window).trigger('flash.error', msgs.join(", "))   
        else
          $(window).trigger('flash.error', "Error rating: #{responseObj.errors}")
    )
    event.preventDefault()

  render: () ->
    game = this.state.game
    user = this.props.user

    inputs =
      id: game.id
      title: game.get('title')
      description: game.get('description')
      board:
        id: game.board?.id
        title: game.board?.title
      seed:
        id: game.seed_thing_id
      invite_only: game.invite_only
      allow_keyword_search: game.allow_keyword_search
      boards: _.sortBy game.get('boards'), 'title'
      filter: game.filter()

    status = if game.id then game.get('state') else 'new'

    `<div className={this.className}>
      <br/>
      <Seed ref="seed" seed={inputs.seed} />
      <div className="games-setup__meta-and-settings">
        <Metadata ref="metadata" title={inputs.title} description={inputs.description} />
        <Settings ref="settings" invite_only={inputs.invite_only} allow_keyword_search={inputs.allow_keyword_search} />
      </div>
      <div className="games-setup__board-and-players">
        <Board ref="board" board={inputs.board} boards={inputs.boards} />
        <Players ref="players" />
      </div>
      <Actions ref="actions" status={status} />
      <Candidates filter={inputs.filter} />
    </div>`

@Sembl.views.gamesSetup = ($el, el) ->
  header = $el.data().header
  Sembl.game = new Sembl.Game($el.data().game);

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setState 
    body: Sembl.Games.Setup.Root({game: Sembl.game, user: Sembl.user}),
    header: Sembl.Games.HeaderView(model: Sembl.game, title: header) 


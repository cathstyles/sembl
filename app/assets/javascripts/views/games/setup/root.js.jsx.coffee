#= require views/games/setup/actions
#= require views/games/setup/metadata
#= require views/games/setup/seed
#= require views/games/setup/board
#= require views/games/setup/players
#= require views/games/setup/settings
#= require views/games/setup/candidates
#= require views/games/gallery
#= require views/games/header_view
#= require views/layouts/default

###* @jsx React.DOM ###

{Actions, Board, Candidates, CandidatesGalleryModal, Filter, Metadata, Players, Seed, Settings} = @Sembl.Games.Setup
{Gallery, HeaderView} = @Sembl.Games
{Searcher} = Sembl.Components
Layout = Sembl.Layouts.Default

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
      url = "/api/games/" + this.state.game.id + ".json"
      params._method = "patch"
    else
      url = "/api/games.json"

    $.ajax(
      url: url
      data: params
      type: 'POST'
      dataType: 'json'
      success: (gameData) =>
        console.log "saved game", data
        Sembl.game = new Sembl.Game(data);
        @setState
          game: Sembl.game
        $(window).trigger('setup.game.saved')
      error: (gameData) =>
        console.log 'error', gameData
    )
    event.preventDefault()

  render: () ->
    game = this.state.game
    user = this.props.user

    inputs =
      id: game.id
      title: game.title
      description: game.description
      board:
        id: game.board?.id
        title: game.board?.title
      seed:
        id: game.seed_thing_id
      invite_only: game.invite_only
      allow_keyword_search: game.allow_keyword_search
      boards: _.sortBy game.get('boards'), 'title'
      filter: game.filter()

    header = `<HeaderView game={game} >
      {this.props.header}
    </HeaderView>`

    status = if game.id then game.get('state') else 'new'

    `<Layout header={header}>
      <br/>
      <div className={this.className}>
        <span className="flash-message">{game.notice}</span>
        <span className="flash-message">{game.alert}</span>
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
      </div>
    </Layout>`

@Sembl.views.gamesSetup = ($el, el) ->
  Sembl.game = new Sembl.Game($el.data().game);
  header = $el.data().header
  React.renderComponent(
    Sembl.Games.Setup.Root
      game: Sembl.game,
      header: header,
      user: Sembl.user
    el
  )

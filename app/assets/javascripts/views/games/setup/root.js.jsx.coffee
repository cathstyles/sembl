#= require views/games/setup/actions
#= require views/games/setup/metadata
#= require views/games/setup/seed
#= require views/games/setup/board
#= require views/games/setup/players
#= require views/games/setup/settings
#= require views/games/setup/selected_thing
#= require views/games/gallery

###* @jsx React.DOM ###
{Actions, Metadata, Seed, Board, Players, Settings, SelectedThing} = @Sembl.Games.Setup
{Gallery} = @Sembl.Games

@Sembl.Games.Setup.Root = React.createClass
  className: "games__setup"

  getInitialState: () ->
    game: this.props.game

  getGameParams: (publish) ->
    params = 
      game:
        board_id:      this.refs.board.state.id
        seed_thing_id: this.refs.seed.state.id
        title:         this.refs.metadata.state.title
        description:   this.refs.metadata.state.description
      authenticity_token: this.props.authenticity_token
    _.extend(params.game, this.refs.settings.getParams())
    console.log "params", params
    params

  handleSave: () ->
    this.updateGame(this.getGameParams())

  handlePublish: () ->
    params = this.getGameParams()
    params.publish = publish
    this.updateGame(params)

  handleSelectSeed: (seed) ->
    this.refs.seed.handleNewSeed(seed)

  updateGame: (params) ->
    self = this
    if this.state.game.id
      url = "/api/games/" + this.state.game.id + ".json"
      params._method = "patch"
    else 
      url = "/api/games.json"

    $.post(
      url
      params,
      (saved_game) ->
        if saved_game.errors.length > 0
          console.log "you have errors"
        else 
          console.log "saved game", saved_game
          self.setState
            game: saved_game
      "json"
    )
    event.preventDefault()

  render: () ->
    game = this.state.game
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
      boards: _.sortBy game.boards, 'title'
      filter: game.filter_content_by

    actionRequests = 
      requestSave: this.handleSave
      requestPublish: this.handlePublish

    galleryRequests = 
      requestSelectSeed: this.handleSelectSeed

    `<div className={this.className}>
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
      <Actions ref="actions" requests={actionRequests} />
      <Gallery filter={inputs.filter} SelectedClass={SelectedThing} requests={galleryRequests} />
    </div>`

@Sembl.views.gamesSetup = ($el, el) ->
  game = $el.data().game
  authenticity_token = $("[name=csrf-token]").attr("content")
  console.log game
  React.renderComponent(
    Sembl.Games.Setup.Root
      game: game, 
      authenticity_token: authenticity_token
    el
  )

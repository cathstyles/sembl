#= require views/games/setup/overview/overview_graph
#= require views/games/setup/overview/actions

###* @jsx React.DOM ###

{OverviewGraph, OverviewActions} = Sembl.Games.Setup
{ThingModal} = Sembl.Components

@Sembl.Games.Setup.Overview = React.createClass
  componentWillMount: ->
    $(window).on('setup.players.give', @handleGivePlayers)

  componentWillUnmount: ->
    $(window).off('setup.players.give', @handleGivePlayers)

  componentDidMount: ->
    $(window).trigger('setup.players.get')

  handleGivePlayers: (event, data)->
    if data.players?
      @setState players: data.players

  getInitialState: ->
    players: []

  handleEdit: (stepName) ->
    $(window).trigger('setup.steps.add', {stepName: stepName})

  render: ->
    status = @props.status
    isDraft = status == 'draft'

    title = @props.title
    description = @props.description
    seed = @props.seed
    board = @props.board
    filter = @props.filter
    boardTitle = board.get('title')

    editLink = (stepName, text) => 
      handleClick = (ev) => 
        @handleEdit(stepName); ev.preventDefault()
      `<a href="#" onClick={handleClick}>{text ? text : "Edit"}</a>`

    # TODO add invitation step, but only once the user has saved the game
    filterComponent = if filter 
      showQuery = (query) -> `<span className="setup__overview__filter__query">{query}</span>`
      textFilter = if filter.text && filter.text != "*"
        `<span>that match {showQuery(filter.text)}</span>`
      placeFilter = if filter.place_filter
        `<span>from place {showQuery(filter.place_filter)}</span>`
      sourceFilter = if filter.access_filter
        `<span>sourced from {showQuery(filter.access_filter)}</span>`

      if textFilter || placeFilter || sourceFilter
        `<div className="setup__overview__filter">
          <span className="setup__overview__item-title">Filters:</span> Images {textFilter} {placeFilter} {sourceFilter} {isDraft ? editLink('filter') : null}
        </div>`
    if !filterComponent
      filterComponent = 
        `<div className="setup__overview__item setup__overview__filter">
          <span className="setup__overview__item-title">Filters:</span> All images are available {isDraft ? editLink('filter') : null}
        </div>`

    {invite_only, uploads_allowed} = @props.settings
    settingsComponent = 
      `<ul className="setup__overview__settings-list">
        <li className="setup__overview__settings-list-item">
          {invite_only ? 'Game is invite only' : 'Anyone may join game'}
        </li>
        <li className="setup__overview__settings-list-item">
        {uploads_allowed ? 'Users can upload images' : 'Users cannot upload images' }
        </li>
      </ul>`

    playerComponents = for player in @state.players
      user = player.get('user')
      name = if user then user.name else player.get('email')
      `<li key={name} className="setup__overview__players-list-item">{name}</li>`
    if playerComponents.length == 0
      playerComponents = if invite_only
          "No players have been invited to this game"
        else 
          "No players have joined this game"

    `<div className="setup__overview">
      <div className="setup__overview__card">
        <div className="setup__overview__top">
          <div className="setup__overview__title">
            <span className="setup__overview__item-title">Title:</span> {title} {editLink('title')}
          </div>
          <div className="setup__overview__description">
            <span className="setup__overview__item-title">Description:</span> {description} {editLink('description', description ? 'Edit' : 'Add')}
          </div>
        </div>
        <div className="setup__overview__middle">
          <div className="setup__overview__settings">
            <span className="setup__overview__item-title">Settings:</span> {editLink('settings')}
            {settingsComponent}
          </div>
        </div>
        <div className="setup__overview__players">
          <div className="setup__overview__item-players">
            <span className="setup__overview__item-title">Players:</span> {isDraft && invite_only ? editLink('players') : null}
              <ul className="setup__overview__players-list">
                {playerComponents}
              </ul>
          </div>
        </div>
        <div className="setup__overview__upload">
          <span className="setup__overview__item-title">Custom images:</span> {editLink('upload', 'Upload')}
        </div>
        <div className="setup__overview__bottom">
          {filterComponent}
        </div>
        <OverviewActions status={status} />
      </div>
      
      <div className="setup__overview__board">
        <div className="setup__overview__board-heading">Board: <em>{boardTitle} {isDraft ? editLink('board', '(Change)') : null}</em></div>
        <OverviewGraph board={board} seed={seed} isDraft={isDraft} />
      </div>
    </div>`

    
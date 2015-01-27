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
    queryFilterParts = []
    checkboxFilterParts = []
    if filter
      showQuery = (query) -> `<span className="setup__overview__filter__query">{query}</span>`
      if filter.text && filter.text != "*"
        queryFilterParts.push `<span>that match {showQuery(filter.text)} </span>`
      if filter.place_filter
        queryFilterParts.push `<span>from place {showQuery(filter.place_filter)} </span>`
      if filter.access_filter
        queryFilterParts.push  `<span>sourced from {showQuery(filter.access_filter)} </span>`

      if filter.exclude_mature
        checkboxFilterParts.push `<li className="setup__overview__filters-list-item">Mature content is excluded.</li>`
      if filter.exclude_sensitive
        checkboxFilterParts.push `<li className="setup__overview__filters-list-item">Sensitive content is excluded.</li>`
      if filter.include_user_contributed
        checkboxFilterParts.push `<li className="setup__overview__filters-list-item">User-contributed content is included.</li>`

    filterComponent = if queryFilterParts.length > 0 || checkboxFilterParts.length > 0
      queryFilter = if queryFilterParts.length > 0
        `<div>Images {queryFilterParts}.</div>`
      else
        `<span>All images are available</span>`

      `<div className="setup__overview__filter">
        <span className="setup__overview__item-title">Filters:</span> {isDraft ? editLink('filter') : null}
        <ul className="setup__overview__filters-list">
          <li className="setup__overview__filters-list-item">{queryFilter}</li>
          {checkboxFilterParts}
        </ul>
      </div>`
    else
      `<div className="setup__overview__item setup__overview__filter">
        <span className="setup__overview__item-title">Filters:</span> {isDraft ? editLink('filter') : null}
        <ul className="setup__overview__filters-list">
          <li className="setup__overview__filters-list-item">All images are available</li>
        </ul>
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

    playerComponents = _.map @state.players, (player, i) ->
      user = player.get('user')
      name = if user and user.name != "" then user.name else player.get('email')
      `<li key={name + i} className="setup__overview__players-list-item">{name}</li>`
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
            <span className="setup__overview__item-title">Players:</span> {invite_only ? editLink('players') : null}
              <ul className="setup__overview__players-list">
                {playerComponents}
              </ul>
          </div>
        </div>
        <div className="setup__overview__upload">
          <span className="setup__overview__item-title">Custom images:</span>
          {invite_only ? editLink('upload', 'Upload') : <em className="setup__help-inline">Only available on invite-only games</em>}
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

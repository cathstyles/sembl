#= require views/games/setup2/overview/overview_graph
#= require views/games/setup2/overview/actions

###* @jsx React.DOM ###

{OverviewGraph, OverviewActions} = Sembl.Games.Setup
{ThingModal} = Sembl.Components

@Sembl.Games.Setup.Overview = React.createClass
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
          Filters: Images {textFilter} {placeFilter} {sourceFilter} {isDraft ? editLink('filter') : null}
        </div>`
    if !filterComponent
      filterComponent = 
        `<div className="setup__overview__filter">
          Filters: All images are available {isDraft ? editLink('filter') : null}
        </div>`

    makeTickCross = (check) ->
      if check 
        `<i className='fa fa-check setup__overview__settings__tick'></i>`
      else
        `<i className='fa fa-times setup__overview__settings__cross'></i>`

    settingsComponent = 
      `<div>
        <div>Invite only {makeTickCross(this.props.settings.invite_only)}</div>
        <div>Uploads allowed {makeTickCross(this.props.settings.uploads_allowed)}</div>
      </div>`

    `<div className="setup__overview">
      <div className="setup__overview__title">
        Title: {title} {editLink('title')} <br/>
      </div>
      <div className="setup__overview__description">
        Description: {description} {editLink('description', description ? 'Edit' : 'Add')}<br/>
      </div>
      <div className="setup__overview__settings">
        Settings: {editLink('settings')}<br/>
        {settingsComponent}
      </div>
      {filterComponent}
      <div>
        Players: {isDraft ? editLink('players') : null}
      </div>

      <div className="setup__overview__board">
        <div>Board: {boardTitle} {isDraft ? editLink('board', 'Edit') : null}</div>
        <OverviewGraph board={board} seed={seed} isDraft={isDraft} />
      </div>

      <OverviewActions status={status} />
    </div>`

    
#= require views/games/setup2/overview/overview_graph
#= require views/games/setup2/overview/actions

###* @jsx React.DOM ###

{OverviewGraph, OverviewActions} = Sembl.Games.Setup

@Sembl.Games.Setup.Overview = React.createClass
  handleEdit: (stepName) ->
    $(window).trigger('setup.steps.add', {stepName: stepName})

  render: ->
    title = @props.title
    description = @props.description
    seed = @props.seed
    board = @props.board
    filter = @props.filter
    boardTitle = board.get('title')

    editLink = (stepName) => 
      handleClick = (ev) => @handleEdit(stepName); ev.preventDefault()
      `<a href="#" onClick={handleClick}>Edit</a>`

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
          Filter images {textFilter} {placeFilter} {sourceFilter} {editLink('filter')}
        </div>`
    if !filterComponent
      filterComponent = 
        `<div className="setup__overview__filter">
          All images are available {editLink('filter')}
        </div>`

    `<div className="setup__overview">
      <div className="setup__overview__title">
        Title: {title} {editLink('title')} <br/>
      </div>
      <div className="setup__overview__title">
        Description: {description} {editLink('description')}<br/>
      </div>
      <div className="setup__overview__seed">
        Seed: <img src={seed.image_admin_url}/> {editLink('seed')}<br/>
      </div>

      <div className="setup__overview__board">
        <div>{boardTitle} {editLink('board')}</div>
        <OverviewGraph board={board} seed={seed} />
      </div>
      {filterComponent}
      <OverviewActions />
    </div>`

    
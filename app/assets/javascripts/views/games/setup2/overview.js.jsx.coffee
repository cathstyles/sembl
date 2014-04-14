#= require views/games/setup2/thumb_board_graph
#= require views/games/setup2/overview_actions

###* @jsx React.DOM ###

{ThumbBoardGraph, OverviewActions} = Sembl.Games.Setup
@Sembl.Games.Setup.Overview = React.createClass
  handleEdit: (stepName) ->
    $(window).trigger('setup.steps.add', {stepName: stepName})

  render: ->
    title = @props.title
    seed = @props.seed
    board = @props.board
    boardTitle = board.get('title')

    editLink = (stepName) => 
      handleClick = (ev) => @handleEdit(stepName); ev.preventDefault()
      `<a href="#" onClick={handleClick}>Edit</a>`

    # TODO add invitation step, but only once the user has saved the game

    `<div className="setup__overview">
      Title: {title} {editLink('title')}<br/>
      Seed: <img src={seed.image_admin_url}/> {editLink('seed')}<br/>
      {boardTitle} {editLink('board')}<br/>
      <ThumbBoardGraph board={board} />
      <OverviewActions />
    </div>`

    
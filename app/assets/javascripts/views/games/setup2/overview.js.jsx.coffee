#= require views/games/setup2/thumb_board_graph
#= require views/games/setup2/filters

###* @jsx React.DOM ###

{ThumbBoardGraph, Filters} = Sembl.Games.Setup
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

    filter = if @props.user?.power || true
      `<Filters filter={{}} />`

    `<div className="setup__overview">
      Title: {title} {editLink('title')}<br/>
      Seed: <img src={seed.image_admin_url}/> {editLink('seed')}<br/>
      {boardTitle} {editLink('board')}<br/>
      <ThumbBoardGraph board={board} />
      {filter}
    </div>`

    
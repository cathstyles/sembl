#= require views/components/graph/graph

###* @jsx React.DOM ###

{Graph} = Sembl.Components.Graph
@Sembl.Games.Setup.Overview = React.createClass
  render: ->
    title = @props.title
    seed = @props.seed
    board = @props.board

    `<div className="setup__overview">
      Title: {title}<br/>
      Seed: <img src={seed.image_admin_url}/><br/>
      Board: {board.title}<br/>
    </div>`

    
###* @jsx React.DOM ###

@Sembl.Games.Setup.Overview = React.createClass
  render: ->
    title = @props.title
    seed = @props.seed
    board = @props.board

    `<div>
      Title: {title}<br/>
      Seed: <img src={seed.image_admin_url}/><br/>
      Board: {board.id}<br/>
    </div>

    
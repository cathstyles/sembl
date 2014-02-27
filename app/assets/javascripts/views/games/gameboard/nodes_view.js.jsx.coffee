#= require views/games/gameboard/node_view

###* @jsx React.DOM ###
{NodeView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.NodesView = React.createClass 
  render: ->

    nodes = @props.nodes.map((node) ->
      `<NodeView key={node.cid} node={node}  />`
    )
    
    `<div className="board__nodes">
        {nodes}
      </div>`


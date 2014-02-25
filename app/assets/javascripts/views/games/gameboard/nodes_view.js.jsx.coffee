#= require views/games/gameboard/node_view

###* @jsx React.DOM ###

Sembl.Games.Gameboard.NodesView = React.createClass 
  render: ->
    NodeView = Sembl.Games.Gameboard.NodeView

    nodes = @props.nodes.map((node) ->
      return `<NodeView key={node.cid} node={node}  />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


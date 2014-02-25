#= require views/games/gameboard/node_view

###* @jsx React.DOM ###
{NodeView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.NodesView = React.createClass 
  render: ->

    nodes = @props.nodes.map((node) ->
      return `<NodeView key={node.cid} node={node}  />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


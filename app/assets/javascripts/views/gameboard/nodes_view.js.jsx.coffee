#= require views/gameboard/node_view

###* @jsx React.DOM ###

Sembl.Gameboard.NodesView = React.createClass 
  render: ->
    NodeView = Sembl.Gameboard.NodeView

    nodes = @props.nodes.map((node) ->
      return `<NodeView key={node.cid} node={node}  />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


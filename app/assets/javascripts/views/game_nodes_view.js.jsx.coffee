#= require views/game_node_view

###* @jsx React.DOM ###

Sembl.GameNodesView = React.createClass 
  render: ->
    GameNodeView = Sembl.GameNodeView

    nodes = @props.nodes.map((node) ->
      return `<GameNodeView key={node.cid} node={node}  />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


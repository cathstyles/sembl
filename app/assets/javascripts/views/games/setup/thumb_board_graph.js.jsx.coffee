#= require views/components/graph/graph

###* @jsx React.DOM ###

{Graph} = Sembl.Components.Graph

class NodeFactory 
  createComponent: (data) ->
    `<div className="setup__thumb-board-graph__node" />`

class MidpointFactory
  createComponent: (data) ->
    `<div className="setup__thumb-board-graph__midpoint" />`

@Sembl.Games.Setup.ThumbBoardGraph = React.createClass
  render: ->
    board = @props.board
    window.board = board

    nodes = for node in board.nodes.models
      x: node.get('x')
      y: node.get('y')

    links = for link in board.links.models
      source: 
        x: link.source.get('x')
        y: link.source.get('y')
      target:
        x: link.target.get('x')
        y: link.target.get('y')

    nodeFactory = new NodeFactory()
    midpointFactory = new MidpointFactory()
    window.board = board
    `<div className="setup__thumb-board-graph">
      <Graph nodes={nodes} links={links} 
        crop={true}
        nodeFactory={nodeFactory} midpointFactory={midpointFactory} />
    </div>`
  
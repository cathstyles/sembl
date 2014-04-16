#= require views/components/graph/graph
#= require views/games/setup2/overview/overview_graph_placement

###* @jsx React.DOM ###

{Graph} = Sembl.Components.Graph
{OverviewGraphPlacement} = Sembl.Games.Setup

class NodeFactory 
  constructor: (@seed, @isDraft) ->

  createComponent: (data) ->
    placement = if @seed and data.round == 0
      `<OverviewGraphPlacement round={data.round} thing={this.seed} isDraft={this.isDraft} />`
    else 
      `<OverviewGraphPlacement round={data.round} />`

    `<div className="game__placement-wrapper">
      {placement}
    </div>`

class MidpointFactory
  createComponent: (data) ->
    `<div className="setup__overview__graph__midpoint" />`

@Sembl.Games.Setup.OverviewGraph = React.createClass
  render: ->
    board = @props.board
    seed = @props.seed

    nodes = for node in board.nodes.models
      round: node.get('round')
      x: node.get('x')
      y: node.get('y')

    links = for link in board.links.models
      source: 
        round: node.get('round')
        x: link.source.get('x')
        y: link.source.get('y')
      target:
        round: node.get('round')
        x: link.target.get('x')
        y: link.target.get('y')

    nodeFactory = new NodeFactory(seed, this.props.isDraft)
    midpointFactory = new MidpointFactory()
    window.board = board
    `<div className="setup__overview__graph">
      <Graph nodes={nodes} links={links} 
        crop={true}
        nodeFactory={nodeFactory} midpointFactory={midpointFactory}
        pathClassName="game__graph__link" />
    </div>`
  
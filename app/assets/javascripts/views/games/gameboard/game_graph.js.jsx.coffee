#= require views/components/graph/graph
#= require views/games/gameboard/placement
#= require views/games/gameboard/placement_factory
#= require views/games/gameboard/resemblance
#= require views/games/gameboard/resemblance_factory

###* @jsx React.DOM ###

{Graph} = Sembl.Components.Graph
{Placement, Resemblance, ResemblanceFactory, PlacementFactory} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.GameGraph = React.createClass 
  render: ->
    game = @props.game
    width = game.width()
    height = game.height()

    nodes = for node in game.nodes.models
      {
        id: node.id
        x: node.get('x')
        y: node.get('y')
      }

    links = for link in game.links.models
      source = link.source()
      target = link.target()
      {
        id: link.id
        source:
          id: source.id
          x: source.get('x')
          y: source.get('y')
        target:
          id: target.id
          x: target.get('x')
          y: target.get('y')
      }

    nodeFactory = new PlacementFactory(game.nodes.models, Placement)
    midpointFactory = new ResemblanceFactory(game.links.models, Resemblance)

    @props.resemblance  
    `<Graph nodes={nodes} links={links}
      nodeFactory={nodeFactory}
      midpointFactory={midpointFactory}
      width={width} height={height} />`
  


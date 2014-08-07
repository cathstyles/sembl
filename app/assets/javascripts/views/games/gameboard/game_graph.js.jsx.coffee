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
      id: node.id
      x: node.get('x')
      y: node.get('y')

    links = for link in game.links.models
      source = link.source()
      target = link.target()

      id: link.id
      source:
        id: source.id
        x: source.get('x')
        y: source.get('y')
      target:
        id: target.id
        x: target.get('x')
        y: target.get('y')

    nodeFactory = new PlacementFactory(game.nodes.models, Placement)
    midpointFactory = new ResemblanceFactory(game.links.models, Resemblance)


    # Merge the `viewable_resemblance` source/target descriptions into
    # the nodeModels to we can pull them out appropriately
    for node in game.nodes.models
      node_id = node.get("id")
      for link in game.links.models
        viewableResemblance = link.get("viewable_resemblance")
        if viewableResemblance?
          source_id = link.get("source_id")
          target_id = link.get("target_id")
          subs = node.get("sub_descriptions")
          if !subs? then subs = []
          if node_id is source_id and viewableResemblance.source_description?
            subs.push(source_id: source_id, target_id: target_id, sub_description: viewableResemblance.source_description)
            node.set("sub_descriptions", subs)
          if node_id is target_id and viewableResemblance.target_description?
            subs.push(source_id: source_id, target_id: target_id, sub_description: viewableResemblance.target_description)
            node.set("sub_descriptions", subs)


    `<Graph nodes={nodes} links={links}
      nodeModels={game.nodes.models}
      nodeFactory={nodeFactory}
      midpointFactory={midpointFactory}
      width={width} height={height} pathClassName="game__graph__link" />`



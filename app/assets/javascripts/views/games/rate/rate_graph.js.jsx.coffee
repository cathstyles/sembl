#= require views/components/graph/graph
#= require views/games/gameboard/placement_factory
#= require views/games/rate/placement
#= require views/games/rate/resemblance

###* @jsx React.DOM ###

###
  Custom graph midpoint factory because the links we pass in wont have ids
###
class ResemblanceFactory
  constructor: (linkModels, @resemblanceClass) ->
    @lookup = {}
    for link in linkModels
      @lookup[link.source().id] = @lookup[link.source().id]||{}
      @lookup[link.source().id][link.target().id] = link

  createComponent: (data) ->
    link = @lookup[data.source.id][data.target.id]
    @resemblanceClass({link: link})

{Graph} = Sembl.Components.Graph
{Placement} = Sembl.Games.Rate
{Resemblance} = Sembl.Games.Rate
{PlacementFactory} = Sembl.Games.Gameboard

@Sembl.Games.Rate.RateGraph = React.createClass
  componentDidMount: ->
    $(window).trigger('graph.resize')

  render: ->
    target = @props.target
    sources = (link.source() for link in @props.links)

    children = for node in sources
      id: node.id
    root = _.extend({children: children}, {id: target.id})
    tree = d3.layout.tree()
    nodes = tree.nodes(root)
    links = tree.links(nodes)
    # d3 makes the root the source which is the reverse of what we want
    links = for link in links
      target: link.source
      source: link.target

    nodeModels = sources
    nodeModels.push(target)

    # Merge the `viewable_resemblance` source/target descriptions into
    # the nodeModels
    for node in nodeModels
      node_id = node.get("id")
      for link in @props.links
        if link.active
          source_id = link.get("source_id")
          target_id = link.get("target_id")
          if node_id is source_id
            node.set("sub_description", link.get("viewable_resemblance").source_description)
          else if node_id is target_id
            node.set("sub_description", link.get("viewable_resemblance").target_description)
          else
            node.set("sub_description", null)

    nodeFactory = new PlacementFactory(nodeModels, Placement)

    midpointFactory = new ResemblanceFactory(@props.links, Resemblance)

    `<div className="move__graph">
      <Graph nodes={nodes} links={links}
        midpointFactory={midpointFactory}
        nodeFactory={nodeFactory} pathClassName="game__graph__link" />
    </div>`



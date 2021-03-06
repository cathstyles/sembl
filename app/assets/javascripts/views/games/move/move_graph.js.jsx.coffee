#= require views/components/graph/graph
#= require views/games/gameboard/placement_factory
#= require views/games/move/placement
#= require views/games/move/resemblance

###* @jsx React.DOM ###

###
  Custom graph midpoint factory because the links we pass in wont have ids
###
class ResemblanceFactory
  constructor: (linkModels, @resemblanceClass, @additionalProps) ->
    @lookup = {}
    for link in linkModels
      @lookup[link.source().id] = @lookup[link.source().id]||{}
      @lookup[link.source().id][link.target().id] = link

  createComponent: (data, props = {}) ->
    link = @lookup[data.source.id][data.target.id]
    @resemblanceClass _.extend {link: link}, @additionalProps, props

{Graph} = Sembl.Components.Graph
{Placement, Resemblance} = Sembl.Games.Move
{PlacementFactory} = Sembl.Games.Gameboard

@Sembl.Games.Move.MoveGraph = React.createClass
  getInitialState: ->
    placedNodes: []

  componentDidMount: ->
    $(window).trigger('graph.resize')
    $(window).on('move.node.setThing', @_handleSetThing)

  componentWillUnmount: ->
    $(window).off('move.node.setThing', @_handleSetThing)

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
        viewableResemblance = link.get("viewable_resemblance")
        if viewableResemblance?
          source_id = link.get("source_id")
          target_id = link.get("target_id")
          subs = node.get("sub_descriptions")
          subs = _.filter subs, (sub) -> !(sub.source_id == source_id && sub.target_id == sub.target_id)
          if !subs? then subs = []
          if node_id is source_id and viewableResemblance.source_description?
            subs.push(source_id: source_id, target_id: target_id, sub_description: viewableResemblance.source_description)
            node.set("sub_descriptions", subs)
          if node_id is target_id and viewableResemblance.target_description?
            subs.push(source_id: source_id, target_id: target_id, sub_description: viewableResemblance.target_description)
            node.set("sub_descriptions", subs)

    nodeFactory = new PlacementFactory(nodeModels, Placement)
    midpointFactory = new ResemblanceFactory(@props.links, Resemblance, {placedNodes: @state.placedNodes})

    `<div className="move__graph">
      <Graph nodes={nodes} links={links}
        nodeModels={nodeModels}
        midpointFactory={midpointFactory}
        nodeFactory={nodeFactory} pathClassName="game__graph__link" />
    </div>`

  _handleSetThing: (event, data) ->
    placedNodes = @state.placedNodes.slice(0)
    placedNodes.push data.node.id
    @setState placedNodes: placedNodes

#= require views/layouts/default
#= require views/games/rate/move_view
#= require views/games/rate/update_rating_view
#= require views/games/rate/navigation_view
#= require views/components/graph/graph


###* @jsx React.DOM ###
{MoveView, UpdateRatingView, NavigationView} = Sembl.Games.Rate
Graph = Sembl.Components.Graph.Graph
Layout = Sembl.Layouts.Default

@Sembl.Games.Rate.RatingView = React.createClass

  moveIndex: 0

  currentMove: -> 
    @props.moves.at(@moveIndex)

  render: ->
    game = @props.game
    move = @currentMove()

    sources = (link.source() for link in move.links.models)

    rootNode = _.extend({children: sources}, move.target_node)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    `<Layout>
      <div className="move">
        <Graph nodes={nodes} links={move.links} />
      </div>
    </Layout>`
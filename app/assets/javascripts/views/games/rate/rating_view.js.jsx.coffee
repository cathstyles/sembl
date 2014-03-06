#= require d3
#= require views/layouts/default
#= require views/games/rate/update_rating_view
#= require views/games/rate/navigation_view
#= require views/games/header_view
#= require views/components/graph/graph


###* @jsx React.DOM ###
{UpdateRatingView, NavigationView} = Sembl.Games.Rate
HeaderView = Sembl.Games.HeaderView
Graph = Sembl.Components.Graph.Graph
Layout = Sembl.Layouts.Default

@Sembl.Games.Rate.RatingView = React.createClass

  getInitialState: -> 
    {
      moveIndex: 0
      linkIndex: 0
      progress: 'rating'
    }

  incrementIndexes: -> 
    move = @currentMove()
    linkCount = move.links.length()
    moveCount = @moves.length()

    if linkCount % @state.linkIndex == 0
      @state.linkIndex = 0
      if moveCount % @state.moveIndex == 0 then @state.progress = "finished" else @state.moveIndex++
    else
      @state.linkIndex++

    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, progress: @state.progress

  currentMove: -> 
    @props.moves.at(@state.moveIndex)

  currentResemblance: -> 
    @props.moves.at(@state.moveIndex).resemblanceAt(@state.linkIndex)

  render: ->
    console.log @props.game
    game = @props.game
    move = @currentMove()

    sources = (link.source() for link in move.links.models)

    rootNode = _.extend({children: sources}, move.target_node)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    header = `<HeaderView game={game} >
      Rating
    </HeaderView>`

    `<Layout className="game" header={header}>
      <div className="move">
        <Graph nodes={nodes} links={move.links} />
        <NavigationView moves={this.props.moves} handleNext={this.incrementIndexes}/>
        <UpdateRatingView move={this.currentMove()} resemblance={this.currentResemblance()}/>
      </div>  
    </Layout>`
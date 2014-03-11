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

  finishedRating: -> 
    console.log "finishedRating"

  incrementIndexes: -> 
    move = @currentMove()
    linkCount = move.links.length
    moveCount = @props.moves.length

    @state.linkIndex++
    if (@state.linkIndex+linkCount) % linkCount  == 0
      @state.linkIndex = 0
      @state.moveIndex++
      if (@state.moveIndex+moveCount) % moveCount == 0 
        @state.moveIndex--
        @state.progress = "finsihed" 
        
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex

  currentMove: -> 
    @props.moves.at(@state.moveIndex)

  currentResemblance: -> 
    @props.moves.at(@state.moveIndex).resemblanceAt(@state.linkIndex)

  render: ->
    game = @props.game
    move = @currentMove()
    resemblance = @currentResemblance()

    sources = (link.source() for link in move.links.models)

    rootNode = _.extend({children: sources}, move.targetNode)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    header = `<HeaderView game={game} >
      Rating
    </HeaderView>`

    `<Layout className="game" header={header}>
      <div className="move">
        <Graph nodes={nodes} links={move.links} />
        <NavigationView moves={this.props.moves} currentResemblance={resemblance} handleNext={this.incrementIndexes}/>
        <UpdateRatingView move={this.currentMove()} resemblance={this.currentResemblance()}/>
      </div>  
    </Layout>`
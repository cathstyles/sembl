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
        @state.progress = "finished" 
        
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, progress: @state.progress

  currentMove: -> 
    @props.moves.at(@state.moveIndex)

  currentLink: -> 
    @props.moves.at(@state.moveIndex).linkAt(@state.linkIndex)

  render: ->
    game = @props.game
    move = @currentMove()
    link = @currentLink()

    sources = (link.source() for link in move.links.models)

    rootNode = _.extend({children: sources}, move.targetNode)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    semblID = link.get('viewable_resemblance').id

    header = `<HeaderView game={game} >
      Rating
    </HeaderView>`

    `<Layout className="game" header={header}>
      <div className="move">
        <div className="rating__info">
          <div className="rating__info__inner">Rate this Sembl for <em>quality</em>, <em>truthfulness</em> and <em>originality</em></div>
        </div>
        <UpdateRatingView move={this.currentMove()} link={this.currentLink()} key={semblID}/>
        <div className="move__graph">
          <Graph nodes={nodes} links={move.links} />
        </div>
        <NavigationView moves={this.props.moves} currentLink={link} handleNext={this.incrementIndexes}/>
      </div>  
    </Layout>`
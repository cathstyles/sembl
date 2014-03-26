#= require views/layouts/default
#= require views/games/rate/update_rating_view
#= require views/games/rate/navigation_view
#= require views/games/rate/resemblance
#= require views/games/header_view
#= require views/components/graph/graph


###* @jsx React.DOM ###
{UpdateRatingView, NavigationView, Resemblance} = Sembl.Games.Rate
HeaderView = Sembl.Games.HeaderView
Graph = Sembl.Components.Graph.Graph
Layout = Sembl.Layouts.Default

@Sembl.Games.Rate.RatingView = React.createBackboneClass

  getInitialState: -> 
    link = @props.moves.at(0).links.at(0)
    link.active = true
    {
      moveIndex: 0
      linkIndex: 0
      progress: 'rating'
      currentLink: link
    }

  updateRated: (link) -> 
    @setState currentLink: link

  endRating: -> 
    postData = authenticity_token: @props.game.get('auth_token')
    $.post "#{@props.game.url()}/end_rating.json", postData, (data) -> 
      Sembl.game.set(data)
      console.log data
      setTimeout -> 
        Sembl.router.navigate("", trigger: true)
      , 800

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
        
    @props.moves.deactivateLinks()
    link = @currentMove().activateLinkAt(@state.linkIndex)
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, currentLink: link

  decrementIndexes: -> 
    moveCount = @props.moves.length

    if @state.linkIndex == 0
      if @state.moveIndex > 0
        @state.moveIndex--
        move = @currentMove()
        linkCount = move.links.length
        @state.linkIndex = linkCount-1
    else 
      @state.linkIndex--
  
    @props.moves.deactivateLinks()
    link = @currentMove().activateLinkAt(@state.linkIndex)
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, currentLink: link

  currentMove: -> 
    @props.moves.at(@state.moveIndex)

  currentLink: -> 
    @currentMove().links.at(@state.linkIndex)

  render: ->
    move = @currentMove()
    sources = (link.source() for link in move.links.models)

    rootNode = _.extend({children: sources}, move.targetNode)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    graphChildClasses = resemblance: Resemblance

    if @state.progress == 'finished'
      finishedDiv = `<div className="flash finished">
        Finished rating! 
      </div>`
      @endRating()

      
    header = `<HeaderView game={this.props.game} >
      Rating
    </HeaderView>`

    `<Layout className="game" header={header}>
      <div className="move">
        <div className="rating__info">
          <div className="rating__info__inner">Rate this Sembl for <em>quality</em>, <em>truthfulness</em> and <em>originality</em></div>
        </div>
        {finishedDiv}
        <UpdateRatingView 
          move={this.currentMove()} 
          link={this.state.currentLink} 
          key={this.state.currentLink.cid}
          handleRated={this.updateRated} 
          />
        <div className="move__graph">
          <Graph 
            nodes={nodes} 
            links={move.links} 
            childClasses={graphChildClasses} 
            />
        </div>
        <NavigationView 
          moves={this.props.moves} 
          currentLink={this.state.currentLink} 
          handleNext={this.incrementIndexes} 
          handleBack={this.decrementIndexes}/>
      </div>  
    </Layout>`
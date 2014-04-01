#= require views/games/rate/update_rating_view
#= require views/games/rate/navigation_view
#= require views/games/rate/resemblance
#= require views/components/graph/graph


###* @jsx React.DOM ###
{UpdateRatingView, NavigationView, Resemblance} = Sembl.Games.Rate
Graph = Sembl.Components.Graph.Graph

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
    result = $.post "#{@props.game.url()}/end_rating.json", postData, (data) -> 
      Sembl.game.set(data)
      if Sembl.game.get('player')?.state == 'playing_turn'
        navigateTo = "results/#{Sembl.game.resultsAvailableForRound()}"
      else
        navigateTo = ""

      setTimeout -> 
        Sembl.router.navigate(navigateTo, trigger: true)
      , 800

    result.fail (response) -> 
      responseObj = JSON.parse response.responseText;
      if response.status == 422 
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))   
      else
        $(window).trigger('flash.error', "Error rating: #{responseObj.errors}")

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


    `<div className="move">
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
    </div>`
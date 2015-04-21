#= require views/games/rate/update_rating_view
#= require views/games/rate/navigation_view
#= require views/games/rate/rate_graph

###* @jsx React.DOM ###
{UpdateRatingView, NavigationView, RateGraph} = Sembl.Games.Rate

@Sembl.Games.Rate.RatingView = React.createBackboneClass

  getInitialState: ->
    if @props.moves.length > 0
      link = @props.moves.at(0).links.at(0)
      link.active = true
      totalLinks = 0
      @props.moves.each (move) ->
        totalLinks = totalLinks + move.links.length
      {
        moveIndex: 0
        linkIndex: 0
        combinedIndex: 0
        progress: 'rating'
        currentLink: link
        totalLinks: (totalLinks - 1)
      }
    else
      @endRating()
      return progress: "finished"

  componentWillMount: ->
    $(window).on('resize', @handleResize)

  componentWillUnmount: ->
    $(window).off('resize', @handleResize)

  handleResize: ->
    $(window).trigger('graph.resize')

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
    @state.combinedIndex = @state.combinedIndex + 1
    if @state.combinedIndex > @state.totalLinks then @state.combinedIndex = @state.totalLinks
    move = @currentMove()
    linkCount = move.links.length
    moveCount = @props.moves.length

    @state.linkIndex++
    if (@state.linkIndex+linkCount) % linkCount  == 0
      @state.linkIndex = 0
      @state.moveIndex++
      if (@state.moveIndex+moveCount) % moveCount == 0
        @state.moveIndex--
        @setState
          progress: "finished"

    @props.moves.deactivateLinks()
    link = @currentMove().activateLinkAt(@state.linkIndex)
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, currentLink: link, combinedIndex: @state.combinedIndex

  decrementIndexes: ->
    @state.combinedIndex = @state.combinedIndex + 1
    if @state.combinedIndex <= 0 then @state.combinedIndex = 0
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
    @setState linkIndex: @state.linkIndex, moveIndex: @state.moveIndex, currentLink: link, combinedIndex: @state.combinedIndex

  currentMove: ->
    @props.moves.at(@state.moveIndex)

  currentLink: ->
    @currentMove().links.at(@state.linkIndex)

  render: ->
    if @props.moves.length > 0
      move = @currentMove()
      sources = (link.source() for link in move.links.models)

      rootNode = _.extend({children: sources}, move.targetNode)
      tree = d3.layout.tree()
      nodes = tree.nodes(rootNode)

      if @state.progress == 'finished'
        $(window).trigger('flash.notice', 'Finished rating!' )
        @endRating()

      `<div className="move">
        <div className="body-wrapper">
          <div className="body-wrapper__outer">
            <div className="body-wrapper__inner">
              <div className="rating__inner">
                <div className="rating__info">
                  <div className="rating__info__inner">Rate this Sembl for <em>quality</em>, <em>truthfulness</em> and <em>originality</em></div>
                </div>
                <UpdateRatingView
                  move={this.currentMove()}
                  link={this.state.currentLink}
                  key={this.state.currentLink.cid}
                  handleRated={this.updateRated}
                  />
                <div className="rate__graph">
                  <RateGraph target={move.targetNode} links={move.links.models} />
                </div>
              </div>
            </div>
          </div>
        </div>
        <NavigationView
            moves={this.props.moves}
            combinedIndex={this.state.combinedIndex}
            totalLinks={this.state.totalLinks}
            currentLink={this.state.currentLink}
            handleNext={this.incrementIndexes}
            handleBack={this.decrementIndexes}/>
      </div>`
    else
      `<div className="move"></div>`

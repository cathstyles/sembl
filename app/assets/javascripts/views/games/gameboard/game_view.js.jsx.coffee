#= require views/games/gameboard/node
#= require views/games/gameboard/resemblance
#= require views/games/gameboard/players_view
#= require views/games/gameboard/status_view
#= require views/layouts/default
#= require views/components/graph/graph
#= require jquery.timer

###* @jsx React.DOM ###

{Node, Resemblance, PlayersView, StatusView} = Sembl.Games.Gameboard
Graph = Sembl.Components.Graph.Graph

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    postData = authenticity_token: @model().get('auth_token')
    result = $.post "#{@model().url()}/join.json", postData, (data) =>
      @model().set(data)
      $(window).trigger('flash.notice', "You have joined! You can start adding images and Sembls to open nodes.") 

    result.fail (response) -> 
      responseObj = JSON.parse response.responseText;
      if response.status == 422 
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))   
      else
        $(window).trigger('flash.error', "Error joining game: #{responseObj.errors}")

  handleEndTurn: -> 
    postData = authenticity_token: @model().get('auth_token')
    result = $.post "#{@model().url()}/end_turn.json", postData, (data) =>
      @model().set(data)
      if @model().get('player')?.state == 'rating'
        $(window).trigger('flash.notice', "Round complete! Beginning rating...")
        setTimeout => 
          @redirectOnStateChange('playing_turn')
        , 1000
      else
        $(window).trigger('flash.notice', "Turn ended. You will be redirected to rating when your opponents have added their moves.") 

    result.fail (response) -> 
      responseObj = JSON.parse response.responseText;
      if response.status == 422 
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))   
      else
        $(window).trigger('flash.error', "Error ending turn: #{responseObj.errors}")

      
  componentWillMount: ->
    $(window).on('resize', @handleResize)
    $(window).on('header.joinGame', @handleJoin)

  componentDidMount: ->
    @handleResize()

    @timer = $.timer =>
      previousState = @model().get('player')?.state
      res = @model().fetch()
      res.done => 
        @redirectOnStateChange(previousState)

    @timer.set
      time: 10000
      autostart: true

  componentDidUpdate: ->
    @handleResize()
    
  componentWillUnmount: ->
    $(window).off('resize')
    @timer.stop()

  handleResize: ->
    mastheadHeight = $('.masthead').height()
    windowHeight = $(window).height()
    $(@refs.graph.getDOMNode()).css('height', (windowHeight - mastheadHeight) + 'px')
    $(window).trigger('graph.resize')

  redirectOnStateChange: (previousState) -> 
    currentState = @model().get('player')?.state
    if currentState == "rating" and currentState != previousState
      Sembl.router.navigate("rate", trigger: true)

  render: ->
    # this width and height will be used to scale the x,y values of the nodes into the width and height of the graph div.
      
    width = @model().width()
    height = @model().height()

   

    nodes = @model().nodes.models
    links = @model().links.models

    for node in nodes
      node.x = node.get('x')
      node.y = node.get('y')

    graphChildClasses = {
      node: Node
      resemblance: Resemblance
    }

    `<div className="game">
      <div ref="graph" className="game__graph">
        <Graph nodes={nodes} links={links} width={width} height={height} childClasses={graphChildClasses} />
      </div>
      <PlayersView players={this.model().players} />
      <StatusView game={this.model()} handleEndTurn={this.handleEndTurn} />
    </div>`
  


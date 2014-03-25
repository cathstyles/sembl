#= require views/games/gameboard/node
#= require views/games/gameboard/players_view
#= require views/games/gameboard/status_view
#= require views/games/header_view
#= require views/layouts/default
#= require views/components/graph/graph

###* @jsx React.DOM ###

{Node, PlayersView, StatusView} = Sembl.Games.Gameboard
HeaderView = Sembl.Games.HeaderView
Layout = Sembl.Layouts.Default
Graph = Sembl.Components.Graph.Graph

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    postData = authenticity_token: @model().get('auth_token')
    $.post "#{@model().url()}/join.json", postData, (data) =>
      @model().set(data)

  handleEndTurn: -> 
    postData = authenticity_token: @model().get('auth_token')
    $.post "#{@model().url()}/end_turn.json", postData, (data) =>
      @model().set(data)
      
  componentWillMount: ->
    $(window).on('resize', @handleResize)

  componentDidMount: ->
    @handleResize()
  componentDidUpdate: ->
    @handleResize()
    
  componentWillUnmount: ->
    $(window).off('resize')

  handleResize: ->
    mastheadHeight = $('.masthead').height()
    windowHeight = $(window).height()
    $(@refs.graph.getDOMNode()).css('height', (windowHeight - mastheadHeight) + 'px')
    $(window).trigger('graph.resize')

  render: ->
    # this width and height will be used to scale the x,y values of the nodes into the width and height of the graph div.

    width = @model().width()
    height = @model().height()

    round = `<div>
        <span className="header__centre-title-word">Round</span>
        <span className="header__centre-title-number">
          {this.model().get('current_round')}
        </span>
      </div>`
    
    header = `<HeaderView game={this.model()} handleJoin={this.handleJoin}>{round}</HeaderView>`

    nodes = @model().nodes.models
    links = @model().links.models

    for node in nodes
      node.x = node.get('x')
      node.y = node.get('y')

    graphChildClasses = {
      node: Node
    }

    `<Layout className="game" header={header}>
      <div className="messages">
      </div>
      <div ref="graph" className="game__graph">
        <Graph nodes={nodes} links={links} width={width} height={height} childClasses={graphChildClasses} />
      </div>
      <PlayersView players={this.model().players} />
      <StatusView game={this.model()} handleEndTurn={this.handleEndTurn} />
    </Layout>`
  


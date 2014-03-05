#= require views/games/gameboard/nodes_view
#= require views/games/gameboard/links_view
#= require views/games/gameboard/players_view
#= require views/games/gameboard/header_view
#= require views/games/gameboard/status_view
#= require views/games/gallery
#= require views/layouts/default
#= require views/components/graph/graph

###* @jsx React.DOM ###

{NodesView, LinksView, HeaderView, PlayersView, StatusView} = Sembl.Games.Gameboard
Layout = Sembl.Layouts.Default
Graph = Sembl.Components.Graph.Graph

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  componentWillMount: ->
    $(window).on('graph.node.click', @handleNodeClick)

  componentWillUnmount: ->
    $(window).off('graph.node.click')

  handleNodeClick: (event, node) ->
    userState = node.get('user_state')
    if userState == 'available'
      Sembl.router.navigate("move/#{node.id}", trigger: true)

  render: ->
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    
    header = `<HeaderView game={this.model()} handleJoin={this.handleJoin}/>`

    nodes = @model().nodes.models
    links = @model().links.models

    for node in nodes
      node.x = node.get('x')
      node.y = node.get('y')

    `<Layout className="game" header={header}>
      <div className="messages">
      </div>
      <div className="board" style={boardCSS}>
        <LinksView width={width} height={height} links={this.model().links}/> 
        <NodesView nodes={this.model().nodes} /> 
      </div>  

      <Graph nodes={nodes} links={links} width={width} height={height} />
      <PlayersView players={this.model().players} />
      <StatusView game={this.model()} />
    </Layout>`
  


#= require views/games/gameboard/nodes_view
#= require views/games/gameboard/links_view
#= require views/games/gameboard/players_view
#= require views/games/gameboard/header_view
#= require views/games/gameboard/status_view
#= require views/games/gallery
#= require views/layouts/default

###* @jsx React.DOM ###

{NodesView, LinksView, HeaderView, PlayersView, StatusView} = Sembl.Games.Gameboard
Layout = Sembl.Layouts.Default

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  render: ->
    console.log this.model().links
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    
    header = `<HeaderView game={this.model()} handleJoin={this.handleJoin}/>`
    
    `<Layout header={header}>
      <div className="game">
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <LinksView width={width} height={height} links={this.model().links}/> 
          <NodesView nodes={this.model().nodes} /> 
        </div>
        <PlayersView players={this.model().players} />
        <StatusView game={this.model()} />
      </div>
    </Layout>`
  


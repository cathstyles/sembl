#= require views/games/gameboard/nodes_view
#= require views/games/gameboard/links_view
#= require views/games/gameboard/players_view
#= require views/games/gameboard/header_view
#= require views/games/gameboard/status_view

#= require views/games/gallery

###* @jsx React.DOM ###


{NodesView, LinksView, HeaderView, PlayersView, StatusView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  render: ->
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    
    return `<div className="game">
        <HeaderView game={this.model()} handleJoin={this.handleJoin}/>
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <LinksView width={width} height={height} links={this.model().links}/> 
          <NodesView nodes={this.model().nodes} /> 
        </div>
        <PlayersView players={this.model().players} />
        <StatusView game={this.model()} />
      </div>`
    


#= require views/games/gameboard/nodes_view
#= require views/games/gameboard/links_view
#= require views/games/gameboard/players_view
#= require views/games/gameboard/header_view
#= require views/games/move/move_maker
#= require views/games/move/selected_thing
#= require views/games/gallery

###* @jsx React.DOM ###

{SelectedThing, MoveMaker, SelectedThing} = Sembl.Games.Move
{Gallery} = Sembl.Games

Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  render: ->
    NodesView = Sembl.Games.Gameboard.NodesView
    LinksView = Sembl.Games.Gameboard.LinksView
    HeaderView = Sembl.Games.Gameboard.HeaderView
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    filter = @model().filter()
    console.log "filter", filter

    return `<div className="game">
        <HeaderView game={this.model()} handleJoin={this.handleJoin}/>
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <LinksView width={width} height={height} links={this.model().links}/> 
          <NodesView nodes={this.model().nodes} /> 
        </div>
        <br />
        <br />
        <MoveMaker game={this.model()}/>
        <Gallery filter={filter} SelectedClass={SelectedThing} />
      </div>`
    


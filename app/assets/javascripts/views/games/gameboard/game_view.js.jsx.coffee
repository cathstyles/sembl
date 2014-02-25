#= require views/games/gameboard/nodes_view
#= require views/games/gameboard/links_view
#= require views/games/gameboard/players_view
#= require views/games/gameboard/header_view
#= require views/games/move/move_maker
#= require views/games/move/selected_thing
#= require views/games/gallery

###* @jsx React.DOM ###

{MoveMaker, SelectedThing} = Sembl.Games.Move
{Gallery} = Sembl.Games
{NodesView, LinksView, HeaderView, PlayersView} = Sembl.Games.Gameboard


Sembl.Games.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  handleSelectThing: (thing) ->
    this.refs.move_maker.handleSelectThing(thing)

  render: ->
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    filter = @model().filter()

    galleryRequests = 
      requestSelectThing: this.handleSelectThing

    return `<div className="game">
        <HeaderView game={this.model()} handleJoin={this.handleJoin}/>
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <LinksView width={width} height={height} links={this.model().links}/> 
          <NodesView nodes={this.model().nodes} /> 
        </div>
        <PlayersView players={this.model().players} />

        <br />
        <br />
        <MoveMaker ref="move_maker" game={this.model()}/>
        <Gallery filter={filter} SelectedClass={SelectedThing} requests={galleryRequests} />
      </div>`
    


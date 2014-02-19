#= require views/gameboard/nodes_view
#= require views/gameboard/links_view
#= require views/gameboard/players_view
#= require views/games/play/move_maker
#= require views/games/play/selected_thing
#= require views/games/gallery

###* @jsx React.DOM ###

{SelectedThing, MoveMaker, SelectedThing} = Sembl.Games.Play
{Gallery} = Sembl.Games

Sembl.Gameboard.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(data)
    )

  render: ->
    NodesView = Sembl.Gameboard.NodesView
    LinksView = Sembl.Gameboard.LinksView
    HeaderView = Sembl.Gameboard.HeaderView
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
    

Sembl.Gameboard.HeaderView = React.createClass
  handleJoin: -> 
    @props.handleJoin()

  render: -> 
    PlayersView = Sembl.Gameboard.PlayersView
    if @props.game.canJoin() 
      joinDiv = `<a className='header__join' onClick={this.handleJoin}>Join Game</a>`

    return `<div className="header">
      {joinDiv}
      <PlayersView players={this.props.game.players} />
    </div>`


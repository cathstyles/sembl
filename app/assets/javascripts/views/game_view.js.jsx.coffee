#= require views/game_nodes_view
#= require views/game_links_view
#= require views/game_players_view
#= require views/games/play/move_maker
#= require views/games/gallery

###* @jsx React.DOM ###

{MoveMaker} = Sembl.Games.Play
{Gallery} = Sembl.Games

Sembl.GameView = React.createBackboneClass 
  handleJoin: ->  
    $.post(
      "#{@model().url()}/join.json"
      {authenticity_token: @model().get('auth_token')}
      (data) =>
        @model().set(is_participating: data.is_participating)
    )

  render: ->
    @model().on('change', -> 
      console.log 'model change'
    )
    GameNodesView = Sembl.GameNodesView
    GameLinksView = Sembl.GameLinksView
    GameHeaderView = Sembl.GameHeaderView
    width = @model().width()
    height = @model().height()
    boardCSS = 
      width: width
      height: height
    filter = @model().filter()
    console.log "filter", filter

    return `<div className="game">
        <GameHeaderView game={this.model()} handleJoin={this.handleJoin}/>
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <GameLinksView width={width} height={height} links={this.model().links}/> 
          <GameNodesView nodes={this.model().nodes} /> 
        </div>
        <br />
        <br />
        <MoveMaker game={this.model()}/>
        <Gallery filter={filter} />
      </div>`
    

Sembl.GameHeaderView = React.createClass
  handleJoin: -> 
    @props.handleJoin()

  render: -> 
    GamePlayersView = Sembl.GamePlayersView
    if @props.game.canJoin() 
      joinDiv = `<a className='header__join' onClick={this.handleJoin}>Join Game</a>`

    return `<div className="header">
      {joinDiv}
      <GamePlayersView players={this.props.game.players} />
    </div>`


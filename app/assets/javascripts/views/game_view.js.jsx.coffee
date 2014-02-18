#= require views/game_nodes_view
#= require views/game_links_view


###* @jsx React.DOM ###

Sembl.GameView = React.createBackboneClass 
  getInitialState: -> 
    return {
      model: @props.model
    }

  handleJoin: ->  
    $.post(
      "#{@model.urlRoot}/#{@model.id}/join.json"
      {authenticity_token: @model.get('auth_token')}
      (data) =>
        @model().set(data)
        @setState model: @model()
        
        #Handle errors.
    )

  render: ->
    joinDiv = ""
    if @state.model.canJoin() 
      joinDiv = `<div className='header__join'>Join Game</div>`

    GameNodesView = Sembl.GameNodesView
    GameLinksView = Sembl.GameLinksView
    width = @state.model.width()
    height = @state.model.height()
    boardCSS = 
      width: width
      height: height

    return `<div className="game">
        <div className="header">
          {joinDiv}
        </div>
        <div className="messages">
        </div>
        <div className="board" style={boardCSS}>
          <GameLinksView width={width} height={height} links={this.state.model.links}/> 
          <GameNodesView nodes={this.state.model.nodes}/> 
        </div>
      </div>`
    


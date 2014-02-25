###* @jsx React.DOM ###

Sembl.Games.Gameboard.HeaderView = React.createClass
  handleJoin: -> 
    @props.handleJoin()

  render: -> 
    PlayersView = Sembl.Games.Gameboard.PlayersView
    if @props.game.canJoin() 
      joinDiv = `<a className='header__join' onClick={this.handleJoin}>Join Game</a>`

    return `<div className="header">
      {joinDiv}
      <PlayersView players={this.props.game.players} />
    </div>`

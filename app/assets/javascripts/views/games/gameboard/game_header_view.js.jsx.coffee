#= require views/games/header_view

###* @jsx React.DOM ###

HeaderView = Sembl.Games.HeaderView
Sembl.Games.Gameboard.GameHeaderView = React.createBackboneClass
  render: -> 
    round = `<div>
        <span className="header__centre-title-word">Round</span>
        <span className="header__centre-title-number">
          {this.model().get('current_round')}
        </span>
      </div>`

    
    @transferPropsTo `<HeaderView title={round} />`
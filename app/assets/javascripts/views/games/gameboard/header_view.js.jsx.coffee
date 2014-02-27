#= require 'jquery'

###* @jsx React.DOM ###

Sembl.Games.Gameboard.MoreInfoView = React.createClass 
  toggleDescriptionPopup: -> 
    el = @isMounted() && @getDOMNode()
    description = $(el).find('.header__description').toggleClass('hidden')

  render: -> 
    `<div>
      <img className="header__more-info" onClick={this.toggleDescriptionPopup} />
      <div className="header__description hidden">
        {this.props.game.get('description')}
      </div>
    </div>`

{MoreInfoView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.HeaderView = React.createClass
  handleJoin: -> 
    @props.handleJoin()

  render: -> 
    game = @props.game

    headerTitle = `<div className="header__title">
        {game.get('title')}
      </div>`

    join = `<a className='header__join' onClick={this.handleJoin}>
      Join Game
    </a>` if game.canJoin()

    round = `<div className="header__round">
        Round 
        <span className="header__round__number">
          {game.get('current_round')}
        </span>
      </div>`

    moreInfo = `<MoreInfoView game={this.props.game}/>` if  !!game.get('description')

    admin = `<div className="header__admin">
        Admin
      </div>` if game.get('is_hosting') 

    roundResults = `<div className="header__round-results">
        Round Results 
      </div>`
      
    help = `<div className="header__help">
        Help
      </div>`

    return `<div className="header">
      {headerTitle}
      {moreInfo}
      {round}
      {join}
      {roundResults}
      {help}
    </div>`



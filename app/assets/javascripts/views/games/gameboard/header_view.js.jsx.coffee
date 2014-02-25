#= require 'jquery'

###* @jsx React.DOM ###

Sembl.Games.Gameboard.HeaderView = React.createClass
  handleJoin: -> 
    @props.handleJoin()

  toggleDescriptionPopup: -> 
    el = @isMounted() && @getDOMNode()
    description = $(el).find('.header__description').toggleClass('hidden')


  render: -> 
    game = @props.game

    if game.canJoin() 
      joinDiv = `<a className='header__join' onClick={this.handleJoin}>Join Game</a>`

    if !!game.get('description') 
      moreInfo = `<img className="header__more-info" onClick={this.toggleDescriptionPopup} />`
      descriptionDiv = `<div className="header__description hidden">
          {game.get('description')}
        </div>`

    return `<div className="header">
      <div className="header__title">
        {game.get('title')}
      </div>

      {moreInfo}
      {descriptionDiv}
      <div className="header__round">
        Round 
        <span class="header__round__number">
          {game.get('current_round')}
        </span>
      </div>

      {joinDiv}
      
      <div class="header__admin">
        Admin
      </div>
      <div class=header__round-results>
        Round Results 
      </div> 
      <div className="header__help">
        Help
      </div>

    
    </div>`



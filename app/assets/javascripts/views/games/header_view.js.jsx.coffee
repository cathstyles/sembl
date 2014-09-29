#= require 'jquery'

###* @jsx React.DOM ###

Sembl.Games.MoreInfoView = React.createClass
  toggleDescriptionPopup: ->
    el = @isMounted() && @getDOMNode()
    description = $(el).find('.header__description').toggleClass('hidden')

  render: ->
    `<div className="header__more-info">
      <i className="fa fa-info-circle" onClick={this.toggleDescriptionPopup}></i>
      <div className="header__description hidden">
        {this.props.game.get('description')}
      </div>
    </div>`

{MoreInfoView} = Sembl.Games

Sembl.Games.HeaderView = React.createBackboneClass

  componentDidMount: ->
    @offsetRoundTab();

  offsetRoundTab: ->
    gameplayTabWidth = $('.header__centre-title').outerWidth()
    $('.header__centre-title').css 'margin-left', ((gameplayTabWidth / 2) * -1) + 'px'

  render: ->
    game = @model()
    resultsAvailableForRound = game?.resultsAvailableForRound() && game?.get("is_participating")

    headerTitle = `<h1 className="header__title">
        <a href="#">{game.get('title')}</a>
      </h1>` if game

    moreInfo = `<MoreInfoView game={this.model()}/>` if !!game?.get('description') && game?.get("hostless") != true

    editUrl = "/games/" + game.get('id') + "/edit" if game
    edit = `<li className="header__link">
        <i className="fa fa-pencil header__link-icon"></i>
        <a href={editUrl} className="header__link-anchor">Edit game</a>
      </li>` if game?.get('is_hosting') || game?.get('is_admin')

    if resultsAvailableForRound
      roundResults = `<li className="header__link">
          <i className="fa fa-trophy header__link-icon"></i>
          <a href={'#results/' + resultsAvailableForRound} className="header__link-anchor">
            <span className="header__link-truncate">Round&nbsp;</span>
            Results
          </a>
        </li>`

    return `<div className="header__components">
      {headerTitle}
      {moreInfo}
      <div className="header__centre-title">
        {this.props.title}
      </div>
      <ul className="header__links">
        {roundResults}
        {edit}
      </ul>
    </div>`

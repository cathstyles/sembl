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

  endRound: (e) ->
    e.preventDefault()
    if window.confirm("Are you sure you want to close this round?")
      request = $.ajax({
        method: "post"
        url: "/api/games/#{Sembl.game.id}/end_round"
        data:
          authenticity_token: Sembl.game.get('auth_token')
      })
      request.done (data) ->
        Sembl.game.fetch()
        $(window).trigger('flash.notice', "Round successfully ended.")
        Sembl.router.navigate("/", trigger: true)

      request.error (xhr, text, errorThrown) ->
        $(window).trigger('flash.error', xhr.responseJSON.errors)

  endRoundRating: (e) ->
    e.preventDefault()
    if window.confirm("Are you sure you want to close rating for this round?")
      request = $.ajax({
        method: "post"
        url: "/api/games/#{Sembl.game.id}/end_round_rating"
        data:
          authenticity_token: Sembl.game.get('auth_token')
      })
      request.done (data) ->
        Sembl.game.fetch()
        $(window).trigger('flash.notice', "Rating round successfully ended.")

      request.error (xhr, text, errorThrown) ->
        $(window).trigger('flash.error', xhr.responseJSON.errors)

  isHosting: ->
    game = @model()
    game?.get('is_hosting') || game?.get('is_admin')

  render: ->
    game = @model()
    # TODO WTF does this conditional do?
    resultsAvailableForRound = game?.resultsAvailableForRound() && game?.get("is_participating")

    headerTitle = `<h1 className="header__title">
        <a href="#">{game.get('title')}</a>
      </h1>` if game

    moreInfo = `<MoreInfoView game={this.model()}/>` if !!game?.get('description') && game?.get("hostless") != true

    editUrl = "/games/" + game.get('id') + "/edit" if game
    edit = `<li className="header__link">
        <i className="fa fa-pencil header__link-icon"></i>
        <a href={editUrl} className="header__link-anchor">Edit game</a>
      </li>` if @isHosting()

    if resultsAvailableForRound
      label = if game.get("state") is "completed"
        "Game"
      else
        "Round"
      roundResults = `<li className="header__link">
          <i className="fa fa-trophy header__link-icon"></i>
          <a href={'#results/' + game.resultsAvailableForRound()} className="header__link-anchor">
            <span className="header__link-truncate">{label}&nbsp;</span>
            Results
          </a>
        </li>`

    endRound = if @isHosting() && game.get("state") == "playing"
      `<li className="header__link">
        <i className="fa fa-ban header__link-icon"></i>
        <a href="#endround" className="header__link-anchor" onClick={this.endRound}>End round</a>
      </li>`
    else
      false
    endRating = if @isHosting() && game.get("state") == "rating"
      `<li className="header__link">
        <i className="fa fa-ban header__link-icon"></i>
        <a href="#endrating" className="header__link-anchor" onClick={this.endRoundRating}>End rating</a>
      </li>`
    else
      false

    return `<div className="header__components">
      {headerTitle}
      {moreInfo}
      <div className="header__centre-title">
        {this.props.title}
      </div>
      <ul className="header__links">
        {roundResults}
        {edit}
        {endRound}
        {endRating}
      </ul>
    </div>`

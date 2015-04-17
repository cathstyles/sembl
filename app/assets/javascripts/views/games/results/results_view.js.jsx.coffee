###* @jsx React.DOM ###

{classSet} = React.addons
@Sembl.Games.Results.SemblResult = React.createClass
  render: ->
    {source, target, description, score, scoreRounded, roundWinner, user} = @props
    score = Math.floor(score * 100)
    scoreRounded = Math.floor(score / 10) * 10
    key = "#{source.node.id}.#{target.node.id}"

    className = classSet
      "results__player-move__move": true
      "results__player-move__move--won": roundWinner


    `<div className={className} key={key}>
      <span>{this.props.rid}</span>
      <div className="results__player-move__move__sembl">
        <a href={"#moved/" + this.props.round + "/" + this.props.resemblanceID + "/" + source.node.id + "/" + target.node.id} className="results__player-move__move__sembl__inner">
          <div className="results__player-move__move__source">
            <img className="results__player-move__move__thing" src={source.thing.image_admin_url} />
            {this._formatSubSembl(this.props.source_description, "source")}
          </div>
          <div className="results__player-move__move__target">
            <img className="results__player-move__move__thing" src={target.thing.image_admin_url} />
              {this._formatSubSembl(this.props.target_description, "target")}
          </div>
          <div className={"results__player-move__move__score score--" + scoreRounded}>
            {score}
          </div>
        </a>
      </div>
      <div className="results__player-move__move__description">
        <p>{description}</p>
      </div>
      <div className="results__player-move__move__avatar">
        <span className="game__player__details__avatar">
          {this._getAvatar(this.props.user)}
        </span>
      </div>
    </div>`
  _getAvatar: (user) ->
    if user.avatar_tiny_thumb
      `<img src={user.avatar_tiny_thumb} />`
    else
      name = if user.name? && user.name != "" then user.name else user.email
      # Get initials from name
      _.map(name.split(' ', 2), (item) ->
        item[0].toUpperCase()
      ).join('')
  _formatSubSembl: (description, className) ->
    if description
      `<div className={"results__player-move__move__sub-sembl results__player-move__move__sub-sembl--"+className}>
        <span className="results__player-move__move__sub-sembl__inner">{description}</span>
      </div>`
    else
      ""

{SemblResult} = @Sembl.Games.Results

@Sembl.Games.Results.ResultsRound = React.createClass
  render: ->
    `<div className="results__round">
      <h1 className="results__round__heading">Round {this.props.round}</h1>
      <div>
        {this._formatSemblResults()}
      </div>
    </div>`
  _formatSemblResults: ->
    _this = @
    _.map @props.resemblances, (resemblance) ->
      target = resemblance.result.get("target")
      return SemblResult(
        round: _this.props.round
        resemblanceID: resemblance.id
        roundWinner: resemblance.target_state == "final"
        source: resemblance.source
        target: target
        description: resemblance.description
        source_description: resemblance.source_description
        target_description: resemblance.target_description
        score: resemblance.score || 0
        user: resemblance.result.get("user")
      )

@Sembl.Games.Results.PlayerRoundResults = React.createClass
  render: ->
    _this = @
    playersSorted = _.sortBy(@props.players.slice(0), (player) -> player.score).reverse()
    playerRoundResults = playersSorted.map (player) ->
      name = player.user?.name || player.user?.email
      score = Math.floor(player.score * 100)
      user = player.user

      className = classSet
        "results__player-score": true
        "results__player-score--you": (player.user.email is Sembl.user?.email?)

      `<div className={className}>
        <div className="results__player-score__avatar">
          <span className="game__player__details__avatar">
            {_this._getAvatar(user)}
          </span>
        </div>
        <h1 className="results__player-score__name">
          <em>{name}</em>
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <h1 className="results__aside__heading">Scores and awards</h1>
      <div className="results__player-scores">
        <div className="results__player-scores__inner">
          {playerRoundResults}
        </div>
      </div>
    </div>`
  _getAvatar: (user) ->
    if user.avatar_tiny_thumb
      `<img src={user.avatar_tiny_thumb} />`
    else
      name = if user.name? && user.name != "" then user.name else user.email
      # Get initials from name
      _.map(name.split(' ', 2), (item) ->
        item[0].toUpperCase()
      ).join('')

@Sembl.Games.Results.PlayerAwards = React.createClass
  getInitialState: ->
    awards: null

  componentDidMount: ->
    result = $.get "/api/games/#{@props.game.id}/results/awards.json", (data) =>
      @state.awards = data
      @setState @state


  render: ->
    awards = if @state.awards
      @state.awards.map (award) ->

        className = classSet
          "results__award": true
          "results__award--you": (award.player.user.email is Sembl.user?.email?)

        `<div className={className}>
          <span className="results__award__icon">
            <i className={"fa " + award.icon}></i>
          </span>
          <span className="results__award__name">{award.name}</span>
          <span className="results__award__player">{award.player.user.name}</span>
          <span className="results_award__result-name">{award.result_name + ": "}</span><span className="results_award__result">{award.result.description}</span>
        </div>`
    else
      `<div className="results__awards--fetching">Fetching awards&hellip;</div>`

    `<div className="results__awards-wrapper">
      <div className="results__awards">
        <div className="results__awards__inner">
          {awards}
        </div>
      </div>
    </div>`


@Sembl.Games.Results.PlayerFinalResults = React.createClass
  render: ->
    _this = this
    playersSorted = _.sortBy(@props.players.slice(0), (player) -> player.score).reverse()
    playerRoundResults = _.map playersSorted, (player) ->
      name = player.user?.name
      score = Math.floor(player.score * 100)
      user = player.user

      className = classSet
        "results__player-score": true
        "results__player-score--you": (user.email is Sembl.user?.email?)

      `<div className={className}>
        <div className="results__player-score__avatar">
          <span className="game__player__details__avatar">
            {_this._getAvatar(user)}
          </span>
        </div>
        <h1 className="results__player-score__name">
          <em>{name}</em><br />
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <h1 className="results__aside__heading">Scores and awards</h1>
      <div className="results__player-scores">
        <div className="results__player-scores__inner">
          {playerRoundResults}
        </div>
      </div>
    </div>`
  _getAvatar: (user) ->
    if user.avatar_tiny_thumb
      `<img src={user.avatar_tiny_thumb} />`
    else
      name = if user.name? && user.name != "" then user.name else user.email
      # Get initials from name
      _.map(name.split(' ', 2), (item) ->
        item[0].toUpperCase()
      ).join('')


{ResultsRound, PlayerRoundResults, PlayerFinalResults, PlayerAwards} = @Sembl.Games.Results
@Sembl.Games.Results.ResultsView = React.createClass

  render: ->
    _this = @
    players = @props.game.get('players')
    winner = _.sortBy(players, (player) -> player.score).reverse()[0]

    # Munge into better format
    rounds = {}

    for result in @props.results.models
      targetNode = result.get("target").node
      for resemblance in result.get("resemblances")
        sourceNode = resemblance.source.node
        key = "round-#{targetNode.round}-#{sourceNode.id}-to-#{targetNode.id}"
        unless rounds[key]?
          rounds[key] = []
        rounds[key].push
          score: resemblance.score
          id:    resemblance.id

    # Calculate winning nodes for each rounds
    roundWinners = []
    for round in _.compact rounds
      highscore = 0
      for move in round
        if move.score > highscore
          highscore = move.score
          roundWinner = move
      roundWinners.push(roundWinner)

    # Group the results into their rounds
    resultsByRound = []
    for result in @props.results.models
      round = false
      resemblances = result.get("resemblances")
      if resemblances.length > 0
        # round = resemblances[0].source.node.round
        round = result.get("target").node.round
        resultsByRound[round] = resultsByRound[round] || []
        resultsByRound[round].push result
    # Then group by users too
    resultsByRoundByUsers = _.map resultsByRound, (round) ->
      _.groupBy round, (result) ->
        result.get("user").email

    userGroupedResults = {}
    for result in @props.results.models
      if result.get('user')
        email = result.get('user').email
        userGroupedResults[email] = userGroupedResults[email] || []
        userGroupedResults[email].push(result)

    if @props.game.get('state') is 'completed'
      playerOverallResults = `<PlayerFinalResults players={players} />`
      playerAwards = `<PlayerAwards game={this.props.game}/>`
    else
      playerOverallResults = `<PlayerRoundResults players={players} />`

    resultsRounds = _.map resultsByRound, (results, index) ->
      # Sort resemblances by score
      resemblances = []
      _.each results, (result) ->
        _.each result.get("resemblances"), (resemblance) ->
          resemblance.result = result
          resemblances.push(resemblance)
      resemblances = _.sortBy resemblances, (resemblance) -> 1 - resemblance.score
      `<ResultsRound round={index} resemblances={resemblances} roundWinners={roundWinners}/>`

    `<div className="body-wrapper">
      <div className="body-wrapper__outer">
        <div className="results">
          <div className="results__back-to-game__container">
            <span className="results__back-to-game__border">
              <a className="results__back-to-game" href="#">
                <i className="fa fa-chevron-left"></i>&nbsp;
                Back to the gameboard
              </a>
            </span>
          </div>
          <div className="results__container">
            {resultsRounds}
          </div>
          <div className="results__aside">
            {playerOverallResults}
            {playerAwards}
          </div>
        </div>
      </div>
    </div>`



###* @jsx React.DOM ###

{classSet} = React.addons
@Sembl.Games.Results.SemblResult = React.createClass
  render: ->
    {source, target, description, score, scoreRounded, roundWinner} = @props
    score = Math.floor(score * 100)
    scoreRounded = Math.floor(score / 10) * 10
    key = "#{source.node.id}.#{target.node.id}"

    className = classSet
      "results__player-move__move": true
      "results__player-move__move--won": roundWinner

    `<div className={className} key={key}>
      <div className="results__player-move__move__sembl">
        <div className="results__player-move__move__sembl__inner">
          <div className="results__player-move__move__source">
            <img className="results__player-move__move__thing" src={source.thing.image_admin_url} />
          </div>
          <div className="results__player-move__move__target">
            <img className="results__player-move__move__thing" src={target.thing.image_admin_url} />
          </div>
          <div className={"results__player-move__move__score score--" + scoreRounded}>
            {score}
          </div>
        </div>
      </div>
      <div className="results__player-move__move__description">
        <p>{description}</p>
      </div>
    </div>`

{SemblResult} = @Sembl.Games.Results
@Sembl.Games.Results.MoveResult = React.createClass
  render: ->
    result = @props.result
    target = result.get('target')
    Sembl.results = Sembl.results || []
    Sembl.results.push(result)
    semblResults = for resemblance in result.get('resemblances')
      params =
        roundWinner: _.contains(_.pluck(@props.roundWinners, "id"), resemblance.id)
        source: resemblance.source
        target: target
        description: resemblance.description
        score: resemblance.score || 0
      SemblResult(params)
    `<div className="results__move-result">
      <h2>Round {this.props.round}</h2>
      {semblResults}
    </div>`

{MoveResult} = @Sembl.Games.Results
@Sembl.Games.Results.PlayerMoveResults = React.createClass
  render: ->
    _this = @
    user = @props.results[0].get('user')
    moveResults = _.map @props.results, (result, index) ->
      `<MoveResult result={result} round={index + 1} roundWinners={_this.props.roundWinners}/>`
    className = classSet
      "results__player-move": true
      "results__player-move--winner": (@props.game.get('state') is 'completed' and @props.leader is true)
      "results__player-move--leader": (@props.game.get('state') is not 'completed' and @props.leader is true)

    `<div className={className}>
      <h1 className="results__player-move__name">
        <em><span className="results__player-move__name-username">{user.name}</span></em>
      </h1>
      {moveResults}
    </div>`


@Sembl.Games.Results.PlayerGroup = React.createClass
  render: ->
    `<div className="results__grouped">
      {this._formatSemblResults()}
    </div>`
  _formatSemblResults: ->
    _.map @props.results, (result) ->
      target = result.get('target')
      Sembl.results = Sembl.results || []
      Sembl.results.push(result)
      semblResults = for resemblance in result.get('resemblances')
        params =
          # roundWinner: _.contains(_.pluck(@props.roundWinners, "id"), resemblance.id)
          source: resemblance.source
          target: target
          description: resemblance.description
          score: resemblance.score || 0
        SemblResult(params)

{PlayerGroup} = @Sembl.Games.Results
@Sembl.Games.Results.ResultsRound = React.createClass
  render: ->
    `<div className="results__round">
      <h1 className="results__round__heading">Round {this.props.round}</h1>
      <div>
        {this._formatPlayerGroups()}
      </div>
    </div>`
  _formatPlayerGroups: ->
    _.map @props.resultsByPlayer, (group) ->
      user = group[0].get("user")
      `<PlayerGroup user={user} results={group}/>`

@Sembl.Games.Results.PlayerRoundResults = React.createClass
  render: ->
    playerRoundResults = @props.players.map (player) ->
      name = player.user?.name || player.user?.email
      score = Math.floor(player.score * 100)
      # TODO: Add a highlight class to "results__player-score" <div> to indicate "you"
      # you = if @Sembl.id is id then " results__player-score--you" else ""
      className = classSet
        "results__player-score": true
        "results__player-score--you": (player.user?email is Sembl.user.email)

      `<div className={className}>
        <h1 className="results__player-score__name">
          <em>{name}</em>
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <div className="results__player-scores">
        <h2 className="results__player-scores-title"><i className="fa fa-star"></i> The scores so far:</h2>
        <div className="results__player-scores__inner">
          {playerRoundResults}
        </div>
      </div>
    </div>`

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
        `<div className="results__award">
          <img src={award.icon} className="results__award__icon"/>
          <span className="results__award__name">{award.name}</span>
          <span className="results__award__player">{award.player.user.name}</span>
          <span className="results_award__result-name">{award.result_name + ": "}</span><span className="results_award__result">{award.result}</span>
        </div>`
    else
      `<div className="results__awards--fetching">Fetching awards&hellip;</div>`


    `<div className="results__awards-wrapper">
      <div className="results__awards">
        <h2 className="results__awards-title"><i className="fa fa-trophy"></i> Stats and Awards</h2>
        <div className="results__awards__inner">
          {awards}
        </div>
      </div>
    </div>`


@Sembl.Games.Results.PlayerFinalResults = React.createClass
  render: ->
    playersSorted = _.sortBy(@props.players.slice(0), (player) -> player.score).reverse()
    playerRoundResults = _.map playersSorted, (player) ->
      name = player.user?.name
      score = Math.floor(player.score * 100)
      `<div className="results__player-score">
        <h1 className="results__player-score__name">
          <em>{name}</em>
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <div className="results__player-scores">
        <h2 className="results__player-scores-title"><i className="fa fa-star"></i> Final Results!</h2>
        <div className="results__player-scores__inner">
          {playerRoundResults}
        </div>
      </div>
    </div>`


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
        round = resemblances[0].source.node.round
        resultsByRound[round] = resultsByRound[round] || []
        resultsByRound[round].push result
    # Then group by users too
    resultsByRoundByUsers = _.map resultsByRound, (round) ->
      _.groupBy round, (result) ->
        result.get("user").email

    userGroupedResults = {}
    for result in @props.results.models
      email = result.get('user').email
      userGroupedResults[email] = userGroupedResults[email] || []
      userGroupedResults[email].push(result)

    if @props.game.get('state') is 'completed'
      playerOverallResults = `<PlayerFinalResults players={players} />`
      playerAwards = `<PlayerAwards game={this.props.game}/>`
    else
      playerOverallResults = `<PlayerRoundResults players={players} />`

    # playerMoveResults = for email, results of userGroupedResults
    #   key = email
    #   leader = (winner.user.email is email)
    #   `<PlayerMoveResults key={key} results={results} game={_this.props.game} leader={leader} roundWinners={roundWinners}/>`

    resultsRounds = _.map resultsByRoundByUsers, (round, index) ->
      `<ResultsRound round={index + 1} resultsByPlayer={round}/>`

    `<div className="body-wrapper">
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
    </div>`



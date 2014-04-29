###* @jsx React.DOM ###

@Sembl.Games.Results.SemblResult = React.createClass
  render: ->
    {source, target, description, score} = @props
    score = Math.floor(score * 100)
    key = "#{source.node.id}.#{target.node.id}"
    `<div className="results__player-move__move" key={key}>
      <div className="results__player-move__move__node-wrapper">
        <div className="results__player-move__move__source">
          <img className="results__player-move__move__thing" src={source.thing.image_admin_url} />
        </div>
        <div className="results__player-move__move__target">
          <img className="results__player-move__move__thing" src={target.thing.image_admin_url} />
        </div>
      </div>
      <div className="results__player-move__move__sembl">{description}</div>
      <div className="results__player-move__move__score"><i className="fa fa-star"></i><em>{score}</em></div>
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
        source: resemblance.source
        target: target
        description: resemblance.description
        score: result.get('score') || 0 # TODO: This should be the Resemblance score as for multi sembl moves there is a score for each sembl.
      SemblResult(params)
    `<div className="results__move-result">
      {semblResults}
    </div>`

{MoveResult} = @Sembl.Games.Results
@Sembl.Games.Results.PlayerMoveResults = React.createClass
  render: ->
    user = @props.results[0].get('user')
    moveResults = for result in @props.results
      `<MoveResult result={result} />`

    `<div className="results__player-move">
      <h1 className="results__player-move__email">
        <i className="fa fa-user"></i> {user.name}
      </h1>
      <div className="results__player-move__moves">
        {moveResults}
      </div>
    </div>`

@Sembl.Games.Results.PlayerRoundResults = React.createClass
  render: ->
    playerRoundResults = @props.players.map (player) ->
      name = player.user?.name || player.user?.email
      score = Math.floor(player.score * 100)
      `<div className="results__player-score">
        <h1 className="results__player-score__email">
          <i className="fa fa-user"></i> {name}
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <div className="results__player-scores">
        <h2 className="results__player-scores-message">Scores so far:</h2>
        {playerRoundResults}
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
          <span className="results_award__result-name">{award.result_name}</span>
          <span className="results_award__result">{award.result}</span>
        </div>`
    else 
      `<div className="results__awards--fetching">Fetching awards...</div>`


    `<div className="results__awards-wrapper">
      <div className="results__awards">
        <h2 className="results__awards-message">Awards</h2>
        {awards}
      </div>
    </div>`


@Sembl.Games.Results.PlayerFinalResults = React.createClass
  
  render: ->
    playerRoundResults = @props.players.map (player) ->
      email = player.user?.email
      score = Math.floor(player.score * 100)
      `<div className="results__player-score">
        <h1 className="results__player-score__email">
          <i className="fa fa-user"></i> {email}
        </h1>
        <div className="results__player-score__score">
          <i className="fa fa-star"></i><em>{score}</em>
        </div>
      </div>`

    `<div className="results__player-scores-wrapper">
      <div className="results__player-scores">
        <h2 className="results__player-scores-message">Final scores</h2>
        {playerRoundResults}
      </div>
    </div>`


{PlayerMoveResults, PlayerRoundResults, PlayerFinalResults, PlayerAwards} = @Sembl.Games.Results
@Sembl.Games.Results.ResultsView = React.createClass

  render: -> 
    userGroupedResults = {}
    for result in @props.results.models
      email = result.get('user').email
      userGroupedResults[email] = userGroupedResults[email] || []
      userGroupedResults[email].push(result)

    if @props.game.get('state') is 'completed'
      playerOverallResults = `<PlayerFinalResults players={this.props.game.get('players')} />`
      playerAwards = `<PlayerAwards game={this.props.game}/>`
    else
      playerOverallResults = `<PlayerRoundResults players={this.props.game.get('players')} />`

    playerMoveResults = for email, results of userGroupedResults
      key = email
      `<PlayerMoveResults key={key} results={results} />`

    `<div className="results">
      <a className="results__back-to-game" href="#">Back to game</a>
      {playerAwards}
      {playerOverallResults}
      <div className="results__player-moves">
        {playerMoveResults}
      </div>
    </div>`

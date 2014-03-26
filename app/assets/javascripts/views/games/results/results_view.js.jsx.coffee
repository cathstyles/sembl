#= require views/layouts/default
#= require views/games/header_view

###* @jsx React.DOM ###

Layout = Sembl.Layouts.Default
{HeaderView} = Sembl.Games

@Sembl.Games.Results.SemblResult = React.createClass
  render: ->
    {source, target, description, score} = @props
    score = Math.floor(score * 100)
    key = "#{source.node.id}.#{target.node.id}"
    `<div className="results__player__move" key={key}>
      <div className="results__player__move__node-wrapper">
        <div className="results__player__move__source">
          <img className="results__player__move__thing" src={source.thing.image_admin_url} />
        </div>
        <div className="results__player__move__target">
          <img className="results__player__move__thing" src={target.thing.image_admin_url} />
        </div>
      </div>
      <div className="results__player__move__sembl">{description}</div>
      <div className="results__player__move__score"><i className="fa fa-star"></i><em>{score}</em></div>
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
@Sembl.Games.Results.PlayerResults = React.createClass
  render: ->
    user = @props.results[0].get('user')
    moveResults = for result in @props.results
      `<MoveResult result={result} />`

    `<div className="results__player">
      <h1 className="results__player__email"><i className="fa fa-user"></i> {user.email}</h1>
      <div className="results__player__moves">
        {moveResults}
      </div>
    </div>`



{PlayerResults} = @Sembl.Games.Results
@Sembl.Games.Results.ResultsView = React.createClass
  render: -> 
    header = `<HeaderView game={this.props.game} >
      Results
    </HeaderView>`

    userGroupedResults = {}
    for result in @props.results.models
      email = result.get('user').email
      console.log 'user', result.get('user')
      userGroupedResults[email] = userGroupedResults[email] || []
      userGroupedResults[email].push(result)

    playerResults = for email, results of userGroupedResults
      key = email
      `<PlayerResults key={key} results={results} />`

    `<Layout className="game" header={header}>
      <div className="results__players">
        {playerResults}
      </div>
    </Layout>`


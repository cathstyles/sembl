#= require views/layouts/default
#= require views/games/header_view

###* @jsx React.DOM ###

Layout = Sembl.Layouts.Default
{HeaderView} = Sembl.Games

@Sembl.Games.Results.PlayerMove = React.createClass
  render: ->
    result = @props.result
    key = result.source.node.id+"."+result.target.node.id
    `<div className="results__player__move" key={key}>
      <div className="results__player__move__node-wrapper">
        <div className="results__player__move__source">
          <img className="results__player__move__thing" src={result.source.thing.image_admin_url} />
        </div>
        <div className="results__player__move__target">
          <img className="results__player__move__thing" src={result.target.thing.image_admin_url} />
        </div>
      </div>
      <div className="results__player__move__sembl">{result.description}</div>
      <div className="results__player__move__score"><i className="fa fa-star"></i><em>{result.score}</em></div>
    </div>`

{PlayerMove} = @Sembl.Games.Results
@Sembl.Games.Results.Player = React.createClass
  componentWillMount: ->
    # TODO: This is just random data argh!

    randomThing = ->
      Promise.resolve($.ajax({url :'/api/things/random.json', cache: false}));
    resultPromises = for i in [0..2]
      Promise.all([randomThing(), randomThing()]).then((things) =>
        return {
          source:
            node: Sembl.game.nodes.first()
            thing: things[0]
          target:
            node: Sembl.game.nodes.last()
            thing: things[1]
          description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros."
          score: Math.floor(Math.random() * 100)
        }
      )
    Promise.all(resultPromises).then((results) =>
      @setState 
        results: results
    )

  render: ->
    player = @props.player
    console.log 'state', @state
    playerMoves = for result in @state?.results || []
      `<PlayerMove result={result} />`

    user = player.get('user')

    `<div className="results__player">
      <h1 className="results__player__email"><i className="fa fa-user"></i> {user.email}</h1>
      <div className="results__player__moves">
        {playerMoves}
      </div>
    </div>`



{Player} = @Sembl.Games.Results
@Sembl.Games.Results.ResultsView = React.createClass
  render: -> 
    header = `<HeaderView game={this.props.game} >
      Results
    </HeaderView>`

    players = for player in @props.game.players.models
      `<Player key={player.id} player={player} />`

    console.log players
    `<Layout className="game" header={header}>
      <div className="results__players">
        {players}
      </div>
    </Layout>`


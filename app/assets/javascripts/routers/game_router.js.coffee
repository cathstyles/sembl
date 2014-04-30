#= require views/games/gameboard/game_view
#= require views/games/gameboard/game_header_view
#= require views/games/move/move_view
#= require collections/moves
#= require views/games/rate/rating_view
#= require views/games/results/results_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "move/:node_id": "move"
    "results/:round": "results"
    "rate": "rate"

  initialize: (@game) ->
    @layout = React.renderComponent(
      Sembl.Layouts.Default()
      document.getElementsByTagName('body')[0]
    )

  board: ->
    @layout.setProps
      body: Sembl.Games.Gameboard.GameView({model: @game}),
      header: Sembl.Games.Gameboard.GameHeaderView(model: @game)

  move: (nodeID) ->
    node = @game.nodes.get(nodeID)
    @layout.setProps
      body: Sembl.Games.Move.MoveView({node: node, game: @game}),
      header: Sembl.Games.HeaderView(model: @game, title: 'Your Move')

  rate: ->
    moves = new Sembl.Moves([], {rating: true, game: @game})
    res = moves.fetch()
    res.done =>
      @layout.setProps
        body: Sembl.Games.Rate.RatingView({moves: moves, game: @game}),
        header: Sembl.Games.HeaderView(model: @game, title: 'Rate Sembls')


  results: (round) ->
    results = new Sembl.Results([], {game: @game, round: round})
    res = results.fetch()
    title = if @game.get('state') is 'completed' then "Final results" else "Round #{round} Results"

    res.done =>
      @layout.setProps
        body:  Sembl.Games.Results.ResultsView({results: results, game: @game}),
        header: Sembl.Games.HeaderView(model: @game, title: title)


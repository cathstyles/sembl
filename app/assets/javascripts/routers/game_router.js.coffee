#= require views/games/gameboard/game_view
#= require views/games/gameboard/game_header_view
#= require views/games/move/move_view
#= require views/games/move/moved_view
#= require collections/moves
#= require views/games/rate/rating_view
#= require views/games/results/results_view
#= require views/utils/page_title

{PageTitle} = Sembl.Utils

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "move/:node_id":  "move"
    "moved/:source_id/:target_id": "moved"
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
    PageTitle.set @game.get("title")

  move: (nodeID) ->
    node = @game.nodes.get(nodeID)
    @layout.setProps
      body: Sembl.Games.Move.MoveView({node: node, game: @game}),
      header: Sembl.Games.HeaderView(model: @game, title: 'Your Move')
    PageTitle.set "Your move"

  moved: (sourceID, targetID) ->
    source = @game.nodes.get(sourceID)
    target = @game.nodes.get(targetID)
    placement = target.get("viewable_placement")
    creator = placement?.creator
    creatorName = if creator?.name && creator.name? && creator.name != ""
      creator.name
    else if creator?
      creator.email
    else
      "..."

    @layout.setProps
      body: Sembl.Games.Move.MovedView({source: source, target: target, creator: creator, game: @game}),
      header: Sembl.Games.HeaderView(model: @game, title: "Move by #{creatorName}")
    PageTitle.set "Move by #{creatorName}"

  rate: ->
    moves = new Sembl.Moves([], {rating: true, game: @game})
    res = moves.fetch()
    res.done =>
      @layout.setProps
        body: Sembl.Games.Rate.RatingView({moves: moves, game: @game}),
        header: Sembl.Games.HeaderView(model: @game, title: 'Rate Sembls')
      PageTitle.set "Rate Sembls"


  results: (round) ->
    results = new Sembl.Results([], {game: @game, round: round})
    res = results.fetch()
    title = if @game.get('state') is 'completed' then "Final Results" else "Round #{round} Results"
    PageTitle.set title

    res.done =>
      @layout.setProps
        body:  Sembl.Games.Results.ResultsView({results: results, game: @game}),
        header: Sembl.Games.HeaderView(model: @game, title: title)


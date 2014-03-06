#= require views/games/gameboard/game_view
#= require views/games/move/move_view
#= require collections/moves
#= require views/games/rate/rating_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "move/:node_id": "add_move"
    "results/:round": "results"
    "rate": "rate"

  initialize: (@game) ->

  board: ->
    React.unmountComponentAtNode(document.getElementsByTagName('body')[0])
    React.renderComponent(
      Sembl.Games.Gameboard.GameView({model: @game})
      document.getElementsByTagName('body')[0]
    )

  add_move: (nodeID) ->
    React.unmountComponentAtNode(document.getElementsByTagName('body')[0])
    node = @game.nodes.get(nodeID)
    React.renderComponent(
      Sembl.Games.Move.MoveView({node: node, game: @game})
      document.getElementsByTagName('body')[0]
    )

  rate: -> 
    moves = new Sembl.Moves([], {for_round: true, game: @game})
    res = moves.fetch()
    res.done -> 
      React.renderComponent(
        Sembl.Games.Rate.RatingView({moves: moves, game: @game}), 
        document.getElementsByTagName('body')[0]
      )

  results: (round) ->



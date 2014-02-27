#= require views/games/gameboard/game_view
#= require views/games/move/move_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "move/:node_id": "add_move"

  initialize: (@game) ->

  board: ->
    React.renderComponent(
      Sembl.Games.Gameboard.GameView({model: @game})
      document.getElementsByTagName('body')[0]
    )

  add_move: (nodeID) -> 
    console.log @game
    node = @game.nodes.get(nodeID)
    React.renderComponent(
      Sembl.Games.Move.MoveView({game: @game, node: node})
      document.getElementById('container')
    )


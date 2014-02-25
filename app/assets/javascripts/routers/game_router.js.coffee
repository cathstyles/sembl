#= require views/games/gameboard/game_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "propose/:node_id": "propose"

  initialize: (@game) ->

  board: ->
    React.renderComponent(
      Sembl.Games.Gameboard.GameView({model: @game})
      document.getElementById('container')
    )

  propose: (nodeID) -> 
    # node = @game.findNode(nodeID)
    node = Sembl.Node.new()
    React.renderComponent(
      Sembl.Games.Move.MoveView({model: @game, node: node})
      document.getElementById('container')
    )


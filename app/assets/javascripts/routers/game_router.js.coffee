#= require views/games/gameboard/game_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "board"
    "propose/:node_id": "propose"

  initialize: (@game) ->

  board: ->
    layout = Sembl.Layouts.Default(
      {} 
      Sembl.Games.Gameboard.GameView({model: @game})
    )
    React.renderComponent(layout, document.getElementsByTagName('body')[0])

  propose: (nodeID) -> 
    # node = @game.findNode(nodeID)
    node = Sembl.Node.new()
    React.renderComponent(
      Sembl.Games.Move.MoveView({model: @game, node: node})
      document.getElementById('container')
    )


#= require views/game_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "show"

  initialize: (@game) ->

  show: ->
    @gameView = new Sembl.GameView(model: @game)
    $("#container").html(@gameView.el)

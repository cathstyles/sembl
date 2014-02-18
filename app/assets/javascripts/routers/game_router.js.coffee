#= require views/game_view

class Sembl.GameRouter extends Backbone.Router
  routes:
    "": "show"

  initialize: (@game) ->

  show: ->
    React.renderComponent(
      Sembl.GameView({model: @game})
      document.getElementById('container')
    )

#= require views/game_view

class Sembl.GameRouter extends Backbone.Router
  routes: 
    '': 'show'

  initialize: (@game) ->

  show: -> 
    view = new Sembl.GameView(model: @game)
    $('#container').html(view.render().el)

  summary: -> 

  rate: ->


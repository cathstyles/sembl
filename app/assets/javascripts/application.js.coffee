#= require jquery
#= require raphael
#= require underscore
#= require backbone
#= require backbone-raphael
#= require skim
#= require_self
#= require models/game
#= require routers/game_router
#= require_tree ./templates


@Sembl = Sembl =
  version: "0.1"
  init: -> 
    @game = new Sembl.Game($('#container').data('game'))
    @router = new Sembl.GameRouter(@game)
    Backbone.history.start()

_.extend Sembl, Backbone.Events


$(document).ready -> 
  Sembl.init()
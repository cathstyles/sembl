#= require models/player

class Sembl.Players extends Backbone.Collection
  model: Sembl.Player

  initialize: (models, options) ->
    @game = options?.game

  comparator: (player) ->
    score = player.get('score') || 0
    100 - (score*100)


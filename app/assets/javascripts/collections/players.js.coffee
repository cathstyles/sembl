#= require models/player

class Sembl.Players extends Backbone.Collection
  model: Sembl.Player

  initialize: (models, options) ->
    @game = options?.game

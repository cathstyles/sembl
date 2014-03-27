#= require models/result

class Sembl.Results extends Backbone.Collection
  url: ->
    root = "/api/games/#{@game.id}/results/#{@round}.json"

  model: Sembl.Result

  initialize: (models, options) ->
    @game = options?.game
    @round = options?.round


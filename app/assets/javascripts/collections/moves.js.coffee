#= require models/move

class Sembl.Moves extends Backbone.Collection
  url: ->
    root = "/api/games/#{@game.get('id')}/moves" 
    if @for_round then "#{root}/round" else root

  model: Sembl.Move

  initialize: (models, options) ->
    @game = options?.game

    @for_round = options?.for_round

  resemblances: -> 
    out = []
    _.each @models, (move) ->
      out = out.concat move.resemblances

    out
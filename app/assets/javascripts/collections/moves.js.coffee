#= require models/move

class Sembl.Moves extends Backbone.Collection
  url: ->
    root = "/api/games/#{@game.get('id')}/moves" 
    if @for_round then "#{root}/round" else root

  model: Sembl.Move

  initialize: (models, options) ->
    @game = options?.game

    @for_round = options?.for_round

  # TODO: this is an ugly way to get the full list of resemblances
  resemblances: -> 
    _.flatten( @map (move) ->
       move.links.map (link) -> link.get('viewable_resemblance')
    )
    
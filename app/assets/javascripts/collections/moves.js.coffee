#= require models/move

class Sembl.Moves extends Backbone.Collection
  url: ->
    root = "/api/games/#{@game.get('id')}"
    if @rating
      "#{root}/ratings"
    else if @for_round 
      "#{root}/moves/round"
    else
      "#{root}/moves"

  model: Sembl.Move

  initialize: (models, options) ->
    @game = options?.game

    @for_round = options?.for_round
    @rating = options?.rating

  # TODO: this is an ugly way to get the full list of resemblances
  resemblances: -> 
    _.flatten( @map (move) ->
       move.links.map (link) -> link.get('viewable_resemblance')
    )
  
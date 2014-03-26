#= require models/link

class Sembl.Links extends Backbone.Collection
  model: Sembl.Link

  comparator: (link) ->
    link.source().get('x')

  initialize: (models, options) ->
    @game = options?.game

  
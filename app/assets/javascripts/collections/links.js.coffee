#= require models/link

class Sembl.Links extends Backbone.Collection
  model: Sembl.Link

  initialize: (models, options) ->
    @game = options?.game
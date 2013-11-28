#= require models/node

class Sembl.Nodes extends Backbone.Collection
  model: Sembl.Node

  initialize: (models, options) ->
    @game = options?.game
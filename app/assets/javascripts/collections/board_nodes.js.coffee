#= require models/node

class Sembl.BoardNodes extends Backbone.Collection
  model: Sembl.Node

  initialize: (models, options) ->
    @board = options?.board

  selected: ->
    @findWhere(selected: true)

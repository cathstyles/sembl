#= require models/board_node

class Sembl.BoardNodes extends Backbone.Collection
  model: Sembl.BoardNode

  initialize: (models, options) ->
    @board = options?.board

  selected: ->
    @findWhere(selected: true)

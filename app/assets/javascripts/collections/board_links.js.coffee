#= require models/link

class Sembl.BoardLinks extends Backbone.Collection
  model: Sembl.Link

  initialize: (models, options) ->
    @board = options?.board

  between: (a, b) ->
    @find (link) ->
      (link.source == a and link.target == b) or
        (link.source == b and link.target == a)

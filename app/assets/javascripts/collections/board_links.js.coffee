#= require models/board_link

class Sembl.BoardLinks extends Backbone.Collection
  model: Sembl.BoardLink

  initialize: (models, options) ->
    @board = options?.board

  between: (a, b) ->
    @find (link) ->
      (link.source == a and link.target == b) or
        (link.source == b and link.target == a)

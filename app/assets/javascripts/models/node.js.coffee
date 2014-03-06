class Sembl.Node extends Backbone.Model
  initialize: (options) ->
    @game = options?.game or @collection?.game

  
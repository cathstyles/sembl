class Sembl.Result extends Backbone.Model
  url: ->
    null

  initialize: (options) ->
    @game = options?.game or @collection?.game



class Sembl.Link extends Backbone.Model
  initialize: (options) ->
    @game = @collection.game

    @listenTo @source(), "change:x change:y", =>
      @trigger "change:source"
      @trigger "change"
    @listenTo @target(), "change:x change:y", =>
      @trigger "change:target"
      @trigger "change"

  source: ->
    @game.nodes.get(@get("source_id"))

  target: ->
    @game.nodes.get(@get("target_id"))

  source_id: ->
    @source.id

  target_id: ->
    @target.id
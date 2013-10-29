class Sembl.Link extends Backbone.Model
  initialize: (options) ->
    @board = @collection.board

    if @has("source")
      @source = @get("source")
      if _.isNumber(@source)
        @source = @board.nodes.at(@source)
      @listenTo @source, "destroy", ->
        @destroy()

    if @has("target")
      @target = @get("target")
      if _.isNumber(@target)
        @target = @board.nodes.at(@target)
      @listenTo @target, "destroy", ->
        @destroy()

  toJSON: ->
    source: @board.nodes.indexOf(@source)
    target: @board.nodes.indexOf(@target)

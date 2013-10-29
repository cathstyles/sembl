#= require collections/board_nodes
#= require collections/board_links

class Sembl.Board extends Backbone.Model
  initialize: (options) ->
    @nodes = new Sembl.BoardNodes([], board: this)
    @links = new Sembl.BoardLinks([], board: this)

    @nodes.reset(@get("nodes")) if @has("nodes")
    @links.reset(@get("links")) if @has("links")

  toJSON: ->
    nodes: @nodes.toJSON()
    links: @links.toJSON()

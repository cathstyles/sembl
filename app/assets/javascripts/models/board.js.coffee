#= require collections/board_nodes
#= require collections/board_links

class Sembl.Board extends Backbone.Model
  initialize: (options) ->
    @nodes = new Sembl.BoardNodes(@get("nodes"), board: this)
    @links = new Sembl.BoardLinks(@get("links"), board: this)

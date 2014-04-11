#= require collections/board_nodes
#= require collections/board_links

class Sembl.Board extends Backbone.Model
  initialize: (options) ->
    @nodes = new Sembl.BoardNodes(@get("nodes_attributes"), board: this)
    @links = new Sembl.BoardLinks(@get("links_attributes"), board: this)

#= require collections/nodes
#= require collections/links

class Sembl.Game extends Backbone.Model
  urlRoot: "/games"

  initialize: (options) ->
    @nodes = new Sembl.Nodes(@get("nodes"), game: this)
    @links = new Sembl.Links(@get("links"), game: this)

  width: ->
    _(@nodes.pluck("x")).max() + 30 + 50

  height: ->
    _(@nodes.pluck("y")).max() + 30 + 50

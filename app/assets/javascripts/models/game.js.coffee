#= require collections/nodes
#= require collections/links

class Sembl.Game extends Backbone.Model
  urlRoot: '/games'

  initialize: (options) ->  
    @nodes = new Sembl.Nodes(@get("nodes"), board: this)
    @links = new Sembl.Links(@get("links"), board: this)
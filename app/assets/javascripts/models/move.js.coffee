# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  initialize: (options) ->
    @game = options?.game or @collection?.game
    @targetNode = new Sembl.Node(@get("targetNode"), game: @game)
    @links = new Sembl.Links(@get("links"), game: @game)
    @resemblances = []

  addResemblance: (target, description) ->
    @resemblances.push {
      target: target
      description: description
    } 

  linksByXDimension: -> 
    @links.sortBy (link) ->
      link.source().get('x')

  resemblanceAt: (index) -> 
    @linksByXDimension()[index]

  toJson: -> 

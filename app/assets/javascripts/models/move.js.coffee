# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  initialize: (options) ->
    @game = options?.game or @collection?.game
    @targetNode = new Sembl.Node(@get("target_node"), game: @game)
    @links = new Sembl.Links(@get("links"), game: @game)
    @initResemblances()

  addResemblance: (target, description) ->
    @resemblances.push {
      target: target
      description: description
    } 

  initResemblances: -> 
    @resemblances ?= (link.get('viewable_resemblance') for link in @links.models)

  linksByXDimension: -> 
    @links.sortBy (link) ->
      link.source().get('x')

  resemblanceAt: (index) -> 
    link = @linksByXDimension()[index]
    link?.get('viewable_resemblance')

  toJson: -> 

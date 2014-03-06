# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  initialize: (options) ->
    @game = @collection.game
    console.log @game
    @target_node = new Sembl.Node(@get("target_node"), game: @game)
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

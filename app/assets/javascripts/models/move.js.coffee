# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  initialize: (options) ->
    @game = @get('node')?.get('game')

  addResemblance: (target, description) ->
    @resemblances.push {
      target: target
      description
    } 

  toJson: -> 

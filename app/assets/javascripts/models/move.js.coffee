# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  initialize: (options) ->
    @game = @get('node')?.get('game')

  addResemblance: (source, description) ->
    @resemblances.push {
      source: source
      description
    } 

  toJson: -> 

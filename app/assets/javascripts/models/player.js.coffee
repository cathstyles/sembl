class Sembl.Player extends Backbone.Model
  initialize: (options) ->
    @game = @collection.game

  formatted_score: -> 
    Math.floor(@get('score')*100)

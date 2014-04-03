class Sembl.Link extends Backbone.Model
  initialize: (options) ->
    @game = @collection.game

    @listenTo @source(), "change:x change:y", =>
      @trigger "change:source"
      @trigger "change"
    @listenTo @target(), "change:x change:y", =>
      @trigger "change:target"
      @trigger "change"

    @active = false

  source: ->
    @game.nodes.get(@get("source_id"))

  target: ->
    @game.nodes.get(@get("target_id"))

  source_id: ->
    @source.id

  target_id: ->
    @target.id

  scoreClass: (current_user_rating) -> 
    resemblance = @get('viewable_resemblance')
    score = if current_user_rating then resemblance?.rating else resemblance?.score
    if score < 0.20
      'very-low'
    else if score < 0.40
      'low'
    else if score < 0.60
      'medium'
    else if score < 0.80
      'high'
    else 
      'very-high'

class Sembl.Node extends Backbone.Model
  defaults:
    x: 200
    y: 200
    round: 0

  isSelected: ->
    !!@get("selected")

  select: ->
    @set "selected", true

  deselect: ->
    @set "selected", false

  toJSON: ->
    _(super).omit("selected")

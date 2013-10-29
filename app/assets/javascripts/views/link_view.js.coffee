class Sembl.LinkView extends Backbone.RaphaelView
  el: ->
    @paper.path().toBack()
      .attr
        "stroke": "#999"
        "stroke-width": "4px"

  initialize: (options) ->
    @listenTo @model, "change", @render
    @listenTo @model.source, "change", @render
    @listenTo @model.target, "change", @render
    @listenTo @model, "remove", @remove
    @render()

  render: ->
    @el.attr path: "M#{@model.source.get("x")},#{@model.source.get("y")}L#{@model.target.get("x")},#{@model.target.get("y")}"

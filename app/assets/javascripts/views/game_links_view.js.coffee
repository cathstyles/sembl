class Sembl.GameLinksView extends Backbone.View
  tagName: "canvas"

  initialize: ({@width, @height}) ->
    {@game} = @collection
    @listenTo @collection, "change", => @render()
    @render()

  render: ->
    @el.width = @width
    @el.height = @height

    context = @el.getContext("2d")

    # Clear the canvas
    context.clearRect(0, 0, @width, @height)

    # Draw the lines
    context.beginPath()
    context.setLineWidth(2)
    context.setStrokeColor("#c77e1a")
    @collection.each (link) ->
      context.moveTo(link.source().get("x"), link.source().get("y"))
      context.lineTo(link.target().get("x"), link.target().get("y"))
    context.stroke()

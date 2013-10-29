class Sembl.NodeView extends Backbone.RaphaelView
  radius: 30

  # @backCircle is the fill circle
  # @text is the round label
  # @circle masks @text from select clicks
  # @circles is a set of the two circles
  # @el is a set of all three
  el: ->
    @backCircle = @paper.circle().toFront()
      .attr
        "r": @radius
        "fill": "#999"
    @text = @paper.text().toFront()
      .attr
        "fill": "#fff"
        "font-size": "20px"
        "text-anchor": "middle"
    @circle = @paper.circle().toFront()
      .attr
        "r": @radius
        "fill": "transparent"
        "stroke": "#fff"
        "stroke-width": "4px"
    @circles = @paper.set(@backCircle, @circle)
    @paper.set(@backCircle, @text, @circle)

  events:
    "click": "onClick"
    "dblclick": "onDoubleClick"

  initialize: (options) ->
    @el.drag(@onDrag, @onDragStart, @onDragEnd, this, this, this)
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove
    @render()

  render: ->
    @circles.attr
      cx: @model.get("x")
      cy: @model.get("y")
    if @model.get("selected")
      @circle.attr stroke: "#9cf"
      @text.attr fill: "#9cf"
    else
      @circle.attr stroke: "#fff"
      @text.attr fill: "#fff"
    @text.attr
      x: @model.get("x")
      y: @model.get("y")
      text: @model.get("round")

  onDragStart: ->
    [@dragX, @dragY] = [@model.get("x"), @model.get("y")]
  onDrag: (dx, dy, x, y) ->
    @dragged = true
    @model.set(x: @dragX + dx, y: @dragY + dy)
  onDragEnd: ->

  onClick: (event) ->
    event.preventDefault()
    event.stopPropagation()

    return delete @dragged if @dragged

    node = @model
    if node.isSelected()
      node.deselect()
    else if selectedNode = node.collection.selected()
      selectedNode.deselect()
      if existingLink = node.collection.board.links.between(selectedNode, node)
        existingLink.destroy()
      else
        node.collection.board.links.add(source: selectedNode, target: node)
    else
      node.select()

  onDoubleClick: (event) ->
    console.log arguments...
    event.preventDefault()
    event.stopPropagation()
    if newRound = prompt("Round", @model.get("round"))
      @model.set("round", newRound)

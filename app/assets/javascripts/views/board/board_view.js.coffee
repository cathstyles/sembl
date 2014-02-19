#= require views/board/board_node_view
#= require views/board/board_link_view

class Sembl.BoardView extends Backbone.View
  className: "board-view"

  events:
    "click": "onClick"

  initialize: (options) ->
    @paper = Raphael(@el)

    @model.links.each (model) =>
      @addLink(model)
    @model.nodes.each (model) =>
      @addNode(model)

    @listenTo @model.links, "add", (model, collection, options) ->
      @addLink(model)
    @listenTo @model.nodes, "add", (model, collection, options) ->
      @addNode(model)

    $(window).on "keydown.#{@_listenerId}", @onWindowKeydown.bind(this)

  stopListening: ->
    $(window).off ".#{@_listenerId}"
    super

  addLink: (link) ->
    new Sembl.BoardLinkView(paper: @paper, model: link)

  addNode: (node) ->
    new Sembl.BoardNodeView(paper: @paper, model: node)

  onClick: (event) ->
    if selectedNode = @model.nodes.selected()
      selectedNode.deselect()
    else
      @model.nodes.add(x: event.offsetX, y: event.offsetY)

  onWindowKeydown: (event) ->
    if (event.keyCode is 8 or event.keyCode is 46) and selectedNode = @model.nodes.selected()
      event.preventDefault()
      selectedNode.destroy()



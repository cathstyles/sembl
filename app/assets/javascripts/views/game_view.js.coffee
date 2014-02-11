#= require templates/game_view
#= require views/game_node_view
#= require views/game_links_view

class Sembl.GameView extends Backbone.View
  className: "game"

  template: JST["templates/game_view"]

  events: 
    'click .join': 'joinGame'

  initialize: (options) ->
    @width = @model.width()
    @height = @model.height()

    @render()
    @renderNodes()
    @renderLinks()

  render: ->
    @$el.html(@template(game: @model))

    if @model.hasErrors()
      @$el.find('.errors').show()

    @boardEl = @$el.find(".board")
      .css({@width, @height})
    @nodesEl = @boardEl.find(".nodes")
    @linksEl = @boardEl.find(".links")

  renderNodes: ->
    if @nodeViews?.length
      _(@nodeViews).each (view) -> view.remove()

    @nodeViews = []
    @model.nodes.each (node) =>
      view = new Sembl.GameNodeView(model: node)
      @nodeViews.push(view)
      @nodesEl.append(view.el)

  renderLinks: ->
    @linksView = new Sembl.GameLinksView({@width, @height, collection: @model.links})
    @linksEl.append(@linksView.el)

  # TODO this should really be a player/create method that alters the players collection. 
  joinGame: -> 
    $.post(
      "#{@model.urlRoot}/#{@model.id}/join.json"
      {authenticity_token: @model.get('auth_token')}
      (data) =>
        @model.fetch()
        #Handle errors.
    )

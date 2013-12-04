#= require templates/games/show
#= require views/node_view
#= require views/link_view

class Sembl.GameView extends Backbone.View
  initialize: (options) ->
    @render()

  template: JST["templates/games/show"]

  render: ->
    @$el.html(@template(game: @model))
    this

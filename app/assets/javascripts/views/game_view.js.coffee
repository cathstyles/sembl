#= require templates/games/show
#= require views/node_view
#= require views/link_view

class Sembl.GameView extends Backbone.View
  template: HandlebarsTemplates['games/show']

  initialize: (options) ->
    @render()

  render: ->
    $(@el).html(@template(@model.attributes))
    this
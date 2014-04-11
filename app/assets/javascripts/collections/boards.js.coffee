#= require models/board

class Sembl.Boards extends Backbone.Collection
  model: Sembl.Board

  initialize: (models, options) ->

  comparator: 'title'
#= require collections/nodes
#= require collections/links

class Sembl.Game extends Backbone.Model
  urlRoot: "/games"

  initialize: (options) ->
    @nodes = new Sembl.Nodes(@get("nodes"), game: this)
    @links = new Sembl.Links(@get("links"), game: this)
    console.log @get('auth_token')

  width: ->
    _(@nodes.pluck("x")).max() + 30 + 50

  height: ->
    _(@nodes.pluck("y")).max() + 30 + 50

  hasErrors: -> 
    @get('errors') is not null and @get('errors').length > 0

  canJoin: -> 
    !@get('is_participating') and (@get('state') is 'open' or @get('state') is 'joining') 
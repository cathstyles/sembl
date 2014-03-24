#= require collections/nodes
#= require collections/links
#= require collections/players

class Sembl.Game extends Backbone.Model
  urlRoot: "/api/games"

  initialize: (options) ->
    @nodes = new Sembl.Nodes(@get("nodes"), game: this)
    @links = new Sembl.Links(@get("links"), game: this)
    @players = new Sembl.Players(@get("players"), game: this)
    
    @listenTo(@, 'change:players', @updatePlayers)
    @listenTo(@, 'change:nodes', @updateNodes)

  filter: ->
    @.attributes.filter

  updatePlayers: -> 
    @players.reset(@get("players"))

  updateNodes: -> 
    @nodes.reset(@get("nodes"))
    
  width: ->
    _(@nodes.pluck("x")).max()

  height: ->
    _(@nodes.pluck("y")).max()

  hasErrors: -> 
    @get('errors') is not null and @get('errors').length > 0

  canJoin: -> 
    !@get('is_participating') and !@get('is_hosting') and (@get('state') is 'open' or @get('state') is 'joining') 
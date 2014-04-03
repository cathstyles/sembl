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
    @listenTo(@, 'change:links', @updateLinks)

  filter: ->
    @.attributes.filter

  showUrl: ->
    "/games/#{@id}"

  updatePlayers: -> 
    @players.reset(@get("players"))

  updateNodes: -> 
    @nodes.reset(@get("nodes"))

  updateLinks: -> 
    @links.reset(@get("links"))
    
  width: ->
    _(@nodes.pluck("x")).max()

  height: ->
    _(@nodes.pluck("y")).max()

  hasErrors: -> 
    @get('errors') is not null and @get('errors').length > 0

  canJoin: -> 
    !@get('is_participating') and !@get('is_hosting') and (@get('state') is 'open' or @get('state') is 'joining') 

  resultsAvailableForRound: -> 
    if @get('state') == 'complete' then @get('current_round') else @get('current_round')-1
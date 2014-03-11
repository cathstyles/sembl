# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  urlRoot: "/api/moves"

  initialize: (options) ->
    @game = options?.game or @collection?.game
    @targetNode = new Sembl.Node(@get("target_node"), game: @game)
    @links = new Sembl.Links(@get("links"), game: @game)
    @resemblances = {}

  addPlacementThing: (@thing) ->
    @placement = {node_id: @targetNode.id, thing_id: @thing.id}

  addResemblance: (link, description) ->
    @resemblances[link.id] = description || null

  linksByXDimension: -> 
    @links.sortBy (link) ->
      link.source().get('x')

  linkAt: (index) -> 
    link = @linksByXDimension()[index]

  toJSON: -> 
    move:
      game_id: @game.id
      placement: @placement || null
      resemblances: ({link_id: link_id, description: description} for link_id, description of @resemblances)
    authenticity_token: @game.get('auth_token')


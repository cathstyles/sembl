# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  urlRoot: "/api/moves"

  initialize: (options) ->
    @game = options?.game or @collection?.game
    @targetNode = new Sembl.Node(@get("target_node"), game: @game)
    @links = new Sembl.Links(@get("links"), game: @game)
    @resemblances = {}
    @placement = {node_id: @targetNode?.id}

  addPlacementThing: (@thing) ->
    @placement = {node_id: @targetNode.id, thing_id: @thing.id}

  addResemblance: (link, description) ->
    @resemblances[link.id] = description || null

  activateLinkAt: (index) -> 
    @links.at(index).active = true

  toJSON: -> 
    move:
      game_id: @game.id
      placement: @placement || null
      resemblances: ({link_id: link_id, description: description} for link_id, description of @resemblances)
    authenticity_token: @game.get('auth_token')


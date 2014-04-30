# Attributes: node, thing, resemblances 

class Sembl.Move extends Backbone.Model
  url: -> 
    "/api/games/#{@game.id}/moves"

  initialize: (options) ->
    @game = options?.game or @collection?.game
    @targetNode = new Sembl.Node(@get("target_node"), game: @game)
    @links = new Sembl.Links(@get("links"), game: @game)

    @semblLinks = @game.links.where(target_id: @targetNode.id)
    @resemblances = {}
    @placement = {node_id: @targetNode?.id}

  addPlacementThing: (@thing) ->
    @placement = {node_id: @targetNode.id, thing_id: @thing.id}

  addResemblance: (link, description) ->
    @resemblances[link.id] = description || null

  activateLinkAt: (index) -> 
    link = @links.at(index)
    link.active = true 
    link

  isValid: ->
    numLinks = @semblLinks.length
    numResemblances = (desc for linkId,desc of @resemblances).filter((desc)-> !!desc).length
    !!@placement.thing_id && numLinks == numResemblances

  toJSON: -> 
    move:
      game_id: @game.id
      placement: @placement || null
      resemblances: ({link_id: link_id, description: description} for link_id, description of @resemblances)
    authenticity_token: @game.get('auth_token')


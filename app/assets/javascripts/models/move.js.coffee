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

    # Construct the resemblances if there are any valid @semblLinks
    _.each @semblLinks, (link) =>
      resemblance = link.get("viewable_resemblance")
      if resemblance?
        @resemblances[link.get("id")] =
          description: resemblance.description || null
          target_description: resemblance.target_description || null
          source_description: resemblance.source_description || null

  addPlacementThing: (@thing) ->
    @placement = {node_id: @targetNode.id, thing_id: @thing.id}

  addResemblance: (link, description, target_description, source_description) ->
    @resemblances[link.id] =
      description: description || null
      target_description: target_description || null
      source_description: source_description || null

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
      resemblances: (_.extend({link_id: link_id}, descriptions) for link_id, descriptions of @resemblances)
    authenticity_token: @game.get('auth_token')


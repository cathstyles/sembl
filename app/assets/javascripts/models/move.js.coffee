class Sembl.Move

  initialize: (options) ->
    @game_id = null
    @target = null
    @resemblances = []

  setTarget: (node_id, thing_id) ->
    @target = 
      node_id: node_id
      thing_id: thing_id

  addResemblance: (source, description) ->
    @resemblances.push {
      source: source
      description
    } 
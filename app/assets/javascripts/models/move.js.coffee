class Sembl.Move

  initialize: (options) ->
    @game_id = null
    @target = null
    @resemblances = []

  addTarget: (target) ->
    @target = target

  addResemblance: (source, description) ->
    @resemblances.push {
      source: source
      description
    } 
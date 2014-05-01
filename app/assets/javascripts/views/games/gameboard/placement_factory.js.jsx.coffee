###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlacementFactory = class PlacementFactory
  constructor: (nodeModels, @nodeClass) ->
    @lookup = {}
    for model in nodeModels
      @lookup[model.id] = model

  createComponent: (dataWithId) ->
    node = @lookup[dataWithId.id]
    nodeClass = @nodeClass
    delay = parseInt(Math.random()*10)
    className = "game__placement-wrapper delay-#{delay}"
    `<div className={className}>
      <nodeClass node={node} />
    </div>`

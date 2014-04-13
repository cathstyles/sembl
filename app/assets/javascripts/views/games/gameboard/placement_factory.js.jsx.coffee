###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlacementFactory = class PlacementFactory
  constructor: (nodeModels, @nodeClass) ->
    @lookup = {} 
    for model in nodeModels
      @lookup[model.id] = model

  createComponent: (dataWithId) ->
    node = @lookup[dataWithId.id]
    nodeClass = @nodeClass
    `<div className="game__placement-wrapper">
      <nodeClass node={node} />
    </div>`
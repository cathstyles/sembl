###* @jsx React.DOM ###

Sembl.Games.Gameboard.ResemblanceFactory = class ResemblanceFactory
  constructor: (linkModels, @resemblanceClass) ->
    @lookup = {} 
    for model in linkModels
      @lookup[model.id] = model

  createComponent: (dataWithId) ->
    link = @lookup[dataWithId.id]
    @resemblanceClass({link: link})
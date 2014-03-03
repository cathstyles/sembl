#= require views/games/move/move_maker
#= require views/games/move/selected_thing

###* @jsx React.DOM ###

{SelectedThing, MoveMaker} = Sembl.Games.Move
{Gallery} = Sembl.Games

@Sembl.Games.Move.MoveView = React.createClass

  handleSelectThing: (thing) ->
    @refs.move_maker.handleSelectThing(thing)

  render: -> 
    move = new Sembl.Move({
      node: @props.node, 
      thing: null,
      resemblances: []
    })

    node = @props.node

    filter = @props.game.filter()
    galleryRequests = 
      requestSelectThing: @handleSelectThing

    `<div className="move">
      <p>{node.id}</p>
      <p>{game.id}</p>
      <Gallery filter={filter} SelectedClass={SelectedThing} requests={galleryRequests} />
    </div>`
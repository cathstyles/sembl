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
      thing: nil,
      resemblances: []
    })

    filter = @props.game.filter()
    galleryRequests = 
      requestSelectThing: @handleSelectThing

    return `<div class="move">
        <MoveMaker ref="move_maker" model={move}/>
        <Gallery filter={filter} SelectedClass={SelectedThing} requests={galleryRequests} />
      </div>`
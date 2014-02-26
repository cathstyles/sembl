#= require views/games/move/move_maker
#= require views/games/move/selected_thing

###* @jsx React.DOM ###

{SelectedThing, MoveMaker} = Sembl.Games.Move
{Gallery} = Sembl.Games

@Sembl.Games.Move.MoveMaker = React.createClass
   handleSelectThing: (thing) ->
    @refs.move_maker.handleSelectThing(thing)

  render: -> 
    filter = @props.game.filter()
    galleryRequests = 
      requestSelectThing: @handleSelectThing

    return `<MoveMaker ref="move_maker" game={this.model()}/>
        <Gallery filter={filter} SelectedClass={SelectedThing} requests={galleryRequests} />
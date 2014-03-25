#= require views/games/move/placement_modal

###* @jsx React.DOM ###

{PlacementModal} = Sembl.Games.Move
@Sembl.Games.Move.Node = React.createClass
  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    
  componentWillUnmount: ->
    $(window).off('move.node.setThing')

  handleClick: (event, data) ->
    $(window).trigger('modal.open', `<PlacementModal thing={this.state.thing} />`)

  handleSetThing: (event, data) ->
    if data.node.id == @props.node.id
      @setState
        thing: data.thing

  getInitialState: ->
    node = @props.node
    thing = node.get('viewable_placement')?.thing
    if thing
      return {thing: thing}
    else
      return {}

  render: () ->
    image_url = @state.thing?.image_admin_url
    `<div className='move__node' onClick={this.handleClick} >
      <img className='graph__node__image' src={image_url} />
    </div>`



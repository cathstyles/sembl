#= views/components/toggle_component

###* @jsx React.DOM ###

@Sembl.Games.Move.Node = React.createClass
  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    
  componentWillUnmount: ->
    $(window).off('move.node.setThing')

  handleSetThing: (event, data) ->
    if data.node.id == @props.node.id
      @setState
        thing_id: data.thing.id
        image_url: data.thing.image_admin_url

  getInitialState: ->
    node = @props.node
    placement = node.get('viewable_placement')
    if placement != null
      image_url = placement.image_thumb_url
      thing_id = placement.thing_id

    state = 
      image_url: image_url
      thing_id: thing_id

  render: () ->
    `<div className='move__node'>
      <img className='graph__node__image' src={this.state.image_url} />
    </div>`



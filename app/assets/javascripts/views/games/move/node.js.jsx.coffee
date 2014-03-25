#= require views/components/graph/node
#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Node} = Sembl.Components.Graph

@Sembl.Games.Move.Node = React.createClass
  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    
  componentWillUnmount: ->
    $(window).off('move.node.setThing')

  handleClick: (event, data) ->
    if @state.thing
      $(window).trigger('modal.open', `<ThingModal thing={this.state.thing} />`)

  handleSetThing: (event, data) ->
    console.log 'handle set thing', event, data
    if data.node.id == @props.node.id
      @setState
        thing: data.thing
        userState: 'proposed'

  getInitialState: ->
    node = @props.node
    thing = node.get('viewable_placement')?.thing
    if thing
      return {thing: thing}
    else
      return {}

  render: () ->
    image_url = @state.thing?.image_admin_url
    `<div onClick={this.handleClick}>
      <Node node={this.props.node} image_url={image_url} userState={this.state.userState} />
    </div>`



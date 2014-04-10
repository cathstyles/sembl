#= require views/components/graph/node
#= require views/components/thing_modal
#= require views/components/tooltip

###* @jsx React.DOM ###

{ThingModal, Tooltip} = Sembl.Components
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
    if data.node.id == @props.node.id
      @setState
        thing: data.thing
        userState: 'proposed'

  getInitialState: ->
    node = @props.node
    thing = node.get('viewable_placement')?.thing
    {
      thing: thing
      userState: node.get('user_state')
    }

  render: () ->
    round = @props.node.game.get('current_round')

    tooltip = if round == 1 and @state.userState == 'available'
      `<Tooltip className="graph__node__tooltip">
        First choose an image from the gallery
      </Tooltip>`

    image_url = @state.thing?.image_admin_url
    `<div onClick={this.handleClick}>
      <Node node={this.props.node} image_url={image_url} userState={this.state.userState} />
      {tooltip}
    </div>`



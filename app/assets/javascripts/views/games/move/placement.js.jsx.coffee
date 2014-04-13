#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Node} = Sembl.Components.Graph

@Sembl.Games.Move.Placement = React.createClass
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
    state = 
      userState: node.get('user_state')
    if thing
      state.thing = thing
    return state

  render: () ->
    userState = @state.userState
    className = "game__placement state-#{userState}"
    image_url = @state.thing?.image_admin_url

    `<div className={className} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
    </div>`




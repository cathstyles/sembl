#= require views/components/thing_modal
#= require views/components/tooltip

###* @jsx React.DOM ###

{ThingModal, Tooltip} = Sembl.Components
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
    round = @props.node.game.get('current_round')

    tooltip = if round == 1 and @state.userState == 'available'
      `<Tooltip className="graph__node__tooltip">
        First choose an image from the gallery
      </Tooltip>`

    userState = @state.userState
    className = "game__placement state-#{userState}"
    image_url = @state.thing?.image_admin_url

    `<div className={className} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
      {tooltip}
    </div>`




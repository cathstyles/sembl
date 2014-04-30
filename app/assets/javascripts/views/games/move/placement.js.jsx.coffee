###* @jsx React.DOM ###

{Node} = Sembl.Components.Graph

@Sembl.Games.Move.Placement = React.createClass
  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    
  componentWillUnmount: ->
    $(window).off('move.node.setThing', @handleSetThing)

  componentDidMount: -> 
    round = window.Sembl.game.get('current_round')
    if round == 1 and @state.userState == 'available'
      $(window).trigger('flash.notice', "Click the camera to choose an image from the gallery")

  handleClick: (event) ->
    data = 
      node:      @props.node
      thing:     @state.thing
      userState: @state.userState
    $(window).trigger('move.placement.click', data)

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

    alertedClass = ""
    alertedClass = " alerted" if round == 1 and @state.userState == 'available'

    userState = @state.userState
    className = "game__placement state-#{userState}"
    image_url = @state.thing?.image_admin_url

    `<div className={className + alertedClass} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
    </div>`




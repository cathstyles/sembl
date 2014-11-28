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
    event?.preventDefault()
    data =
      node:      @props.node
      thing:     @state.thing
      userState: @state.userState
    $(window).trigger('move.placement.click', data)

  handleMetadataClick: (event) ->
    event?.preventDefault()
    data =
      node:      @props.node
      thing:     @state.thing
      userState: false
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

  render: ->
    round = @props.node.game.get('current_round')

    alertedClass = ""
    alertedClass = " alerted" if round == 1 and @state.userState == 'available'

    userState = @state.userState
    className = "game__placement state-#{userState}"
    image_url = @state.thing?.image_admin_url

    # Format the sub-description
    subDescription = @props.node.get("sub_description")
    subDescriptionNode = if subDescription?
      `<div className="game__placement__sub-description">{subDescription}</div>`
    else
      ""

    # Format view image button
    viewImageButton = if @state.userState == "proposed"
      `<a href="#metadata" onClick={this.handleMetadataClick} className="game__placement__view-image">
        View&nbsp;image
      </a>`
    else
      ""

    `<div className={className + alertedClass}>
      <a href="#move" className="game__placement__link" onClick={this.handleClick}>
        <img className="game__placement__image" src={image_url} ref="image" />
      </a>
      {viewImageButton}
      {subDescriptionNode}
    </div>`

###* @jsx React.DOM ###

{ResemblanceModal} = Sembl.Games.Move
@Sembl.Games.Move.Resemblance = React.createClass

  componentWillMount: ->
    $(window).on('move.node.setThing', @handleSetThing)
    $(window).on('move.resemblance.change', @handleResemblanceChange)

  componentWillUnmount: ->
    $(window).off('move.node.setThing', @handleSetThing)
    $(window).off('move.resemblance.change', @handleResemblanceChange)


  handleClick: (event, link) ->
    $(window).trigger('move.resemblance.click',
      link: @props.link
      description: @state.description
      target_description: @state.target_description
      source_description: @state.source_description
    )

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.link.id == @props.link.id
      @setState
        description: resemblance.description

  handleSetThing: (event, data) ->
    if data.node.id == @props.link.target().id
      round = window.Sembl.game.get('current_round')
      @setState
        linkFilled: true
      if round == 1 and !!!@state.description
        $(window).trigger('flash.notice', 'Top choice!')

  getInitialState: ->
    link = @props.link
    resemblance = link.get('viewable_resemblance')
    description = if !!resemblance then resemblance.description
    target_description = if !!resemblance then resemblance.target_description
    source_description = if !!resemblance then resemblance.source_description
    state =
      description: description
      target_description: target_description
      source_description: source_description
      nodeState: link.target().get('user_state')
      linkFilled: _.contains @props.placedNodes, link.target().id

  componentDidUpdate: ->
    round = window.Sembl.game.get('current_round')
    if round == 1 and !!@state.description
      $(window).trigger('flash.notice', 'Well assembled, you.')

  render: () ->
    toggleEvent = 'toggle.graph.resemblance.'+@props.link.id

    # Format the sub-description
    source_id = @props.link.get("source_id")
    target_id = @props.link.get("target_id")
    sourceSubDescriptions = _.where @props.sourceNode.get("sub_descriptions"), {source_id: source_id, target_id: target_id}
    targetSubDescriptions = _.where @props.targetNode.get("sub_descriptions"), {source_id: source_id, target_id: target_id}

    sourceSubDescriptionNode = if sourceSubDescriptions.length > 0
      style =
        left: @props.scaledSourceNode.x - @props.midpointPosition.x
        top:  @props.scaledSourceNode.y - @props.midpointPosition.y
      `<div style={style} className="game__resemblance__sub-description">
        <div className="game__resemblance__sub-description__inner">
          {sourceSubDescriptions[0].sub_description}
        </div>
      </div>`
    else
      ""
    targetSubDescriptionNode = if targetSubDescriptions.length > 0
      style =
        left: @props.scaledTargetNode.x - @props.midpointPosition.x
        top:  @props.scaledTargetNode.y - @props.midpointPosition.y
      `<div style={style} className="game__resemblance__sub-description">
        <div className="game__resemblance__sub-description__inner">
          {targetSubDescriptions[0].sub_description}
        </div>
      </div>`
    else
      ""

    child = if @state.description
      `<div className="game__resemblance__expanded">
        <div className="game__resemblance__expanded__inner">
          {this.state.description}
        </div>
      </div>`
    else
      `<div className={"game__resemblance__empty"} />`

    tooltip = if @state.linkFilled && !@state.description
      `<div className="game__resemblance__tip">Add a description</div>`
    else
      ""

    `<div className="move__resemblance" onClick={this.handleClick}>
      {tooltip}
      {sourceSubDescriptionNode}
      {child}
      {targetSubDescriptionNode}
    </div>`


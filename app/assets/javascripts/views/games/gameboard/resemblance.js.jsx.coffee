#= require jquery

###* @jsx React.DOM ###

{classSet} = React.addons

@Sembl.Games.Gameboard.Resemblance = React.createClass
  handleClick: (event) ->
    event.preventDefault()
    viewable_resemblance = @props.link.get('viewable_resemblance')
    Sembl.router.navigate("#moved/#{@props.link.get('round')}/#{viewable_resemblance.id}/#{@props.link.get("source_id")}/#{@props.link.get("target_id")}", trigger: true)

  render: ->
    resemblance = @props.link.get('viewable_resemblance')
    scoreClass = @props.link.scoreClass()

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

    child = if resemblance?.description
      editButton = if @props.playingTurn and @props.targetNode.get("user_state") == "proposed"
        `<a className="game__resemblance__edit-move" href={"#move/" + this.props.targetNode.get("id")}>
          Edit
        </a>`
      else
        ""
      expandedClassNames = classSet
        "game__resemblance__expanded": true
        "game__resemblance__expanded--playing-turn": @props.playingTurn
      `<div>
        <div className={'game__resemblance__filled game__resemblance__filled--' + scoreClass} />
        <div className={expandedClassNames}>
          <a href="#resemblance" className="game__resemblance__expanded__inner" onClick={this.handleClick}>
            {resemblance.description}
          </a>
        </div>
        {editButton}
      </div>`
    else
      `<div className="game__resemblance__empty" />`

    classNames = classSet
      "game__resemblance": true
      "game__resemblance--playing-turn": @props.playingTurn

    `<div className={classNames}>
      {sourceSubDescriptionNode}
      {child}
      {targetSubDescriptionNode}
    </div>`


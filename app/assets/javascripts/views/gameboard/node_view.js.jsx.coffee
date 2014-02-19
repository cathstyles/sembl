#= require views/gameboard/placement_summary_view

###* @jsx React.DOM ###

Sembl.Gameboard.NodeView = React.createClass
  handleMouseEnter: ->
    $(@getDOMNode()).animate(width: 80, height: 80, margin: -40, 200)

  handleMouseLeave: ->
    $(@getDOMNode()).animate(width: 60, height: 60, margin: -30, 200)

  render: ->
    style = 
      position: "absolute"
      left: @props.node.get('x')
      top: @props.node.get('y')

    PlacementSummaryView = Sembl.Gameboard.PlacementSummaryView
    placement = @props.node.get('viewable_placement')
    console.log @props.node.attributes
    state = @props.node.get('user_state')
    return `<div className="board__node"  
        style={style}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}>
        <PlacementSummaryView state={state} placement={placement} />
      </div>`




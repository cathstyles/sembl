#= require views/games/gameboard/placement_summary_view
#= require views/games/gameboard/placement_detail_view

###* @jsx React.DOM ###

{PlacementSummaryView, PlacementDetailView} = Sembl.Games.Gameboard

Sembl.Games.Gameboard.NodeView = React.createClass
  handleMouseEnter: ->
    $(@getDOMNode()).animate(width: 80, height: 80, margin: -40, 200)

  handleMouseLeave: ->
    $(@getDOMNode()).animate(width: 60, height: 60, margin: -30, 200)

  render: ->
    style = 
      position: "absolute"
      left: @props.node.get('x')
      top: @props.node.get('y')

    placement = @props.node.get('viewable_placement')
    state = @props.node.get('user_state')
    return `<div className="board__node"  
        style={style}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}>
        <PlacementSummaryView state={state} placement={placement} node={this.props.node.attributes} />
        <PlacementDetailView state={state} placement={placement} node={this.props.node.attributes} />
      </div>`



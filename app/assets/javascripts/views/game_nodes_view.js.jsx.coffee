###* @jsx React.DOM ###

Sembl.GameNodesView = React.createClass 
  render: ->
    console.log 'rendering nodes'
    GameNodeView = Sembl.GameNodeView

    nodes = @props.nodes.map((node) ->
      return `<GameNodeView key={node.cid} node={node}  />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`

Sembl.GameNodeView = React.createClass

  handleMouseEnter: ->
    $(@getDOMNode()).animate(width: 80, height: 80, margin: -40, 200)

  handleMouseLeave: ->
    $(@getDOMNode()).animate(width: 60, height: 60, margin: -30, 200)

  render: ->
    console.log "rendering node #{this.props.node.get('id')}, round #{this.props.node.get('round')}"
    style = 
      position: "absolute"
      left: @props.node.get('x')
      top: @props.node.get('y')

    return `<div className="board__node"  
        style={style}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}>
      </div>`




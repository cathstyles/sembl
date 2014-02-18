###* @jsx React.DOM ###

Sembl.GameNodesView = React.createBackboneClass 
  render: ->
    GameNodeView = Sembl.GameNodeView

    nodes = this.props.nodes.map((node) ->
      return `<GameNodeView key={node.get('id')} node={node} />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


Sembl.GameNodeView = React.createBackboneClass

  handleMouseEnter: ->
    $(@el()).animate(width: 80, height: 80, margin: -40, 200)

  handleMouseLeave: ->
    $(@el()).animate(width: 60, height: 60, margin: -30, 200)

  render: ->
    style = 
      position: "absolute"
      left: this.props.node.get('x')
      top: this.props.node.get('y')

    return `<div className="board__node" 
        style={style}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}>
      </div>`




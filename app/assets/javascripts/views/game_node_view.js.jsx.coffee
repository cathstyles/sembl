###* @jsx React.DOM ###

Sembl.GameNodeView = React.createClass
  handleMouseEnter: ->
    $(@getDOMNode()).animate(width: 80, height: 80, margin: -40, 200)

  handleMouseLeave: ->
    $(@getDOMNode()).animate(width: 60, height: 60, margin: -30, 200)

  render: ->
    style = 
      position: "absolute"
      left: @props.node.get('x')
      top: @props.node.get('y')

    return `<div className="board__node"  
        style={style}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}>
      </div>`




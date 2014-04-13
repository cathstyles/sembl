###* @jsx React.DOM ###

Node = React.createClass
  render: ->
    {node, nodeFactory} = @props
    style = 
      left: node.x
      top: node.y

    `<div className="graph__node" style={style}>
      {nodeFactory.createComponent(node)}
    </div>`

Sembl.Components.Graph.Nodes = React.createClass
  render: ->
    nodes = for node in @props.nodes
      `<Node node={node} nodeFactory={this.props.nodeFactory}/>`
      
    `<div className="graph__nodes">
      {nodes}
    </div>`

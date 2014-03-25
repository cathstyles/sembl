#= require views/components/graph/node

###* @jsx React.DOM ###

{Node} = Sembl.Components.Graph
Sembl.Components.Graph.Nodes = React.createClass
  render: ->
    nodeClass = @props.childClasses?.node || Node
    nodes = for node in @props.nodes
      style = 
        left: node.x
        top: node.y
      `<div className="graph__node-wrapper" style={style}>
        <nodeClass key={node.model.id} node={node.model} />
      </div>`

    `<div className='graph__nodes'>
      {nodes}
    </div>`

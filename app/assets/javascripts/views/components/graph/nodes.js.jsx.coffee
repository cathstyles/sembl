
###* @jsx React.DOM ###

Sembl.Components.Graph.Node = React.createClass
  handleClick: (event) ->
    $(window).trigger('graph.node.click', @props.node.model)

  render: ->
    node = @props.node
    style = 
      left: node.x
      top: node.y

    userState = node.model.get('user_state')
    className = "graph__node state-#{userState}"
    
    placement = node.model.get('viewable_placement')
    if placement != null
      image_url = placement.image_thumb_url
    
    if this.props.children
      child = this.props.children
    else
      child = `<img className="graph__node__image" src={image_url} />`

    `<div className={className} style={style} onClick={this.handleClick}>
      {child}
    </div>`

{Node} = Sembl.Components.Graph
Sembl.Components.Graph.Nodes = React.createClass
  render: ->
    nodes = for node in @props.nodes
      if @props.childClasses.node
        child = @props.childClasses.node({node: node.model})
      `<Node key={node.model.id} node={node}>{child}</Node>`

    `<div className='graph__nodes'>
      {nodes}
    </div>`

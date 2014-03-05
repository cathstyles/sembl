
###* @jsx React.DOM ###

Sembl.Components.Graph.Node = React.createClass
  handleClick: (event) ->
    $(window).trigger('graph.node.click', @props.node.model)

  render: ->
    node = @props.node
    style = 
      left: node.x
      top: node.y

    placement = node.model.get('viewable_placement')
    if placement != null
      image_url = placement.image_thumb_url

    userState = node.model.get('user_state')
    className = "graph__node state-#{userState}"

    `<div className={className} style={style} 
      onClick={this.handleClick}>
      <img className='graph__node__image' src={image_url} />
    </div>`

Node = Sembl.Components.Graph.Node
Sembl.Components.Graph.Nodes = React.createClass
  render: ->
    nodes = for node in @props.nodes
      `<Node node={node}/>`

    `<div className='graph__nodes'>
      {nodes}
    </div>`

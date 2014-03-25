###* @jsx React.DOM ###

Sembl.Components.Graph.Node = React.createClass
  handleClick: (event) ->
    $(window).trigger('graph.node.click', @props.node)

  render: ->
    node = @props.node
    userState = @props.userState || node.get('user_state')
    className = "graph__node state-#{userState}"
    
    thing = node.get('viewable_placement')?.thing
    image_url = @props.image_url || thing?.image_admin_url
    
    `<div className={className} onClick={this.handleClick}>
      <img className="graph__node__image" src={image_url} />
    </div>`

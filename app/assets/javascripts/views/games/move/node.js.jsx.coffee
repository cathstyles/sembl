
###* @jsx React.DOM ###

Sembl.Games.Move.Node = React.createClass

  render: ->
    node = @props.node
    style = 
        left: node.x
        top: node.y

    if node.get('viewable_placement') != null
      image_url = node.get('viewable_placement').image_thumb_url

    `<div className='move__board__node' style={style} >
      <img className='move__board__node__image' src={image_url} />
    </div>`

#= require d3
#= require views/games/move/links
#= require views/games/move/node


###* @jsx React.DOM ###

{Links, Node} =  Sembl.Games.Move

Sembl.Games.Move.Board = React.createClass 
  getInitialState: ->
    width: null
    height: null

  componentWillMount: ->
    $(window).bind('sembl.move.board.selectTarget', @handleSelectTarget)

  componentDidMount: ->
    @setState
      width: $(".move__board__canvas").width()
      height: $(".move__board__canvas").height()

  componentWillUnmount: ->
    $(window).unbind('sembl.move.board.selectTarget')

  scaleNode: (node) ->
    xScale = d3.scale.linear().range([0, @state.width || 1])
    yScale = d3.scale.linear().range([0, @state.height || 1])
    
    newNode = _.extend({}, node)
    newNode.x = xScale(node.x)
    newNode.y = yScale(node.y)
    newNode

  render: ->
    canvasStyle = {}
    if @state.width then canvasStyle.width = @state.width
    if @state.height then canvasStyle.height = @state.height
    console.log canvasStyle

    nodes = @props.nodes
    links = @props.links

    scaleNode = @scaleNode
    scaledNodes = nodes.map (node) -> scaleNode(node)
    scaledLinks = links.map (link) ->
      source: scaleNode(link.source)
      target: scaleNode(link.target)

    nodeComponents = scaledNodes.map (node) ->
      `<Node key={node.id} node={node} />`

    `<div className="move__board">
      <div className="move__board__canvas" style={canvasStyle}>
        <Links links={scaledLinks} width={this.state.width} height={this.state.height} />
        {nodeComponents}
      </div>
    </div>`
  


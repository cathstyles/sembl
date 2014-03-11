#= require d3
#= require views/components/graph/nodes
#= require views/components/graph/links
#= require views/components/graph/resemblances

###* @jsx React.DOM ###

{Links, Nodes, Resemblances} =  Sembl.Components.Graph
Sembl.Components.Graph.Graph = React.createClass 
  getInitialState: ->
    width: null
    height: null

  lookupNode: (node) ->
    # we use the @props.nodes as the authoritive source on x and y values, so links defer their sources/targets to these.
    if !@nodeIndex
      @nodeIndex = {}
      for n in @props.nodes
        @nodeIndex[n.id] = n
    @nodeIndex[node.id]    

  componentDidMount: ->
    @handleResize()

  handleResize: ->
    $canvas = $(@refs.canvas.getDOMNode())
    if this.state.width != $canvas.width() || this.state.height != $canvas.height()
      @setState
        width: $canvas.width()
        height: $canvas.height()

  scaleNode: (node) ->
    node = @lookupNode(node)

    xScale = d3.scale.linear().range([0, @state.width || 1])
    if @props.width then  xScale.domain([0, @props.width])
    
    yScale = d3.scale.linear().range([0, @state.height || 1])
    if @props.height then yScale.domain([0, @props.height])
    
    newNode =
      x: xScale(node.x)
      y: yScale(node.y)
      model: node
    return newNode

  scaleLink: (link) ->
    newLink = 
      source: @scaleNode(link.source())
      target: @scaleNode(link.target())
      model: link
    return newLink

  render: ->
    canvasStyle = {}
    if @state.width then canvasStyle.width = @state.width
    if @state.height then canvasStyle.height = @state.height

    nodes = @props.nodes
    links = @props.links

    scaleNode = @scaleNode
    scaleLink = @scaleLink
    scaledNodes = nodes.map (node) -> scaleNode(node)
    scaledLinks = links.map (link) -> scaleLink(link)

    `<div className="graph">
      <div ref="canvas" className="graph__canvas" style={canvasStyle}>
        <Links nodes={scaledLinks} links={scaledLinks} width={this.state.width} height={this.state.height} />
        <Resemblances links={scaledLinks} width={this.state.width} height={this.state.height} />
        <Nodes nodes={scaledNodes} />
      </div>
    </div>`
  
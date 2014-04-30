#= require d3
#= require views/components/graph/nodes
#= require views/components/graph/links
#= require views/components/graph/midpoints

###* @jsx React.DOM ###

{Links, Midpoints, Nodes} =  Sembl.Components.Graph
Sembl.Components.Graph.Graph = React.createClass 
  getInitialState: ->
    state =
      width: null
      height: null

  lookupNode: (node) ->
    @nodeIndex[node.id] if node.id

  componentWillMount: ->
    $(window).on "graph.resize", @handleResize
    $(window).on "resize", @handleResize

  componentWillUnmount: ->
    $(window).off "graph.resize", @handleResize
    $(window).off "resize", @handleResize
    
  componentDidMount: ->
    @handleResize()

  handleResize: ->
    $this = $(@getDOMNode())
    window.$this = $this
    if this.state.width != $this.width() || this.state.height != $this.height()
      @setState
        width: $this.width()
        height: $this.height()

  scaleNode: (node) ->
    node = @lookupNode(node) || node

    xScale = d3.scale.linear()
    xScale.range([0, @state.width || 1])
    xScale.domain(@domainWidth())
    
    yScale = d3.scale.linear()
    yScale.range([0, @state.height || 1])
    yScale.domain(@domainHeight())

    newNode = _.extend({}, node)
    newNode.x = xScale(node.x)
    newNode.y = yScale(node.y)
    return newNode

  domainHeight: ->
    if @_domainHeight
      return @_domainHeight
    if @props.crop
      return  (@_domainHeight = @cropDomain().height)
    if @props.height
      return (@_domainHeight = [0, @props.height])
    return (@_domainHeight = [0, 1])

  domainWidth: ->
    if @_domainWidth
      return @_domainWidth
    if @props.crop
      return  (@_domainWidth = @cropDomain().width)
    if @props.width
      return (@_domainWidth = [0, @props.width])
    return (@_domainWidth = [0,1])

  cropDomain: ->
    nodes = @props.nodes
    links = @props.links
    X = (node.x for node in @props.nodes)
    Y = (node.y for node in @props.nodes)
    [minX,maxX] = [Math.min.apply(null,X), Math.max.apply(null,X)]
    [minY,maxY] = [Math.min.apply(null,Y), Math.max.apply(null,Y)]
    domain = {
      width: [minX, maxX]
      height: [minY, maxY]
    }

  scaleLink: (link) ->
    newLink = _.extend({}, link)
    newLink.source = @scaleNode(link.source)
    newLink.target = @scaleNode(link.target)
    return newLink

  render: ->
    # we use the @props.nodes as the authoritive source on x and y values, so links defer their sources/targets to these.
    @nodeIndex = {}
    for node in @props.nodes
      if node.id 
        node.key = node.id
        @nodeIndex[node.id] = node
      else
        node.key = Sembl.Utils.genUUID()

    {nodes, links, nodeFactory, midpointFactory} = @props
    for link in links
      link.key = if link.id then link.id else Sembl.Utils.genUUID()
      if !link.source?
        raise 'link does not have source'
      if !link.target?
        raise 'link does not have target'

    scaledNodes = (@scaleNode(node) for node in nodes)
    scaledLinks = (@scaleLink(link) for link in links)

    childClasses = this.props.childClasses || {}
    {height, width} = @state

    `<div className="graph">
        <Links links={scaledLinks} width={width} height={height} pathClassName={this.props.pathClassName} />
        <Nodes nodes={scaledNodes} nodeFactory={nodeFactory} />
        <Midpoints links={scaledLinks} midpointFactory={midpointFactory} />
    </div>`


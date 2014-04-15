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
    @nodeIndex[node.id]    

  componentWillMount: ->
    $(window).on("graph.resize", @handleResize)

  componentWillUnmount: ->
    $(window).off("graph.resize")
    
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
    node = @lookupNode(node)

    xScale = d3.scale.linear().range([0, @state.width || 1])
    if @props.width then  xScale.domain([0, @props.width])
    
    yScale = d3.scale.linear().range([0, @state.height || 1])
    if @props.height then yScale.domain([0, @props.height])
    
    newNode = _.extend({}, node)
    newNode.x = xScale(node.x)
    newNode.y = yScale(node.y)

    return newNode

  scaleLink: (link) ->
    newLink = _.extend({}, link)
    newLink.source = @scaleNode(link.source)
    newLink.target = @scaleNode(link.target)
    return newLink

  render: ->
    # we use the @props.nodes as the authoritive source on x and y values, so links defer their sources/targets to these.
    @nodeIndex = {}
    for n in @props.nodes
      @nodeIndex[n.id] = n

    {nodes, links, nodeFactory, midpointFactory} = @props
    for link in links
      if !link.source?
        raise 'link does not have source,'

    scaledNodes = (@scaleNode(node) for node in nodes)
    scaledLinks = (@scaleLink(link) for link in links)

    childClasses = this.props.childClasses || {}
    {height, width} = @state

    `<div className="graph">
        <Links links={scaledLinks} width={width} height={height} />
        <Nodes nodes={scaledNodes} nodeFactory={nodeFactory} />
        <Midpoints links={scaledLinks} midpointFactory={midpointFactory} />
    </div>`


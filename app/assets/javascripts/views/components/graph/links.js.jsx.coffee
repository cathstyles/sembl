#= require d3
#= require raphael.js

###* @jsx React.DOM ###

Sembl.Components.Graph.Links = React.createClass
  componentDidMount: -> 
    @drawLinks()

  componentDidUpdate: -> 
    @drawLinks()

  drawLinks: () ->
    lineFunction = d3.svg.diagonal()
    if @paper
      @paper.remove()
    @paper = Raphael(@getDOMNode(), @props.width, @props.height)
    paper = @paper
    
    for link in @props.links
      path = paper.path(lineFunction(link))
      if @props.pathClassName
        path.node.setAttribute("class", @props.pathClassName)

  render: ->
    `<div className="graph__links" pathClassName={this.props.pathClassName} />`


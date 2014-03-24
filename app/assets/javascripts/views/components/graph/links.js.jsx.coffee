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

    $.each(@props.links, (i, link) ->
      paper.path(lineFunction(link)).attr({stroke:'#a9b14a',"stroke-width":2});
    )

  render: ->
    `<div className="graph__links" />`


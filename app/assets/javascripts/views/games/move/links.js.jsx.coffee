#= require d3
#= require raphael.js

###* @jsx React.DOM ###

class Sembl.Games.Move.RaphaelLink
  constructor: (@link) ->

  render: (paper) ->
    lineFunction = d3.svg.diagonal()
    path_data = lineFunction(@link)
    path = paper.path(path_data)

Sembl.Games.Move.Links = React.createClass
  componentDidMount: -> 
    @drawLines()

  componentDidUpdate: -> 
    @drawLines()

  drawLines: ->
    if @paper
      @paper.remove()
    @paper = Raphael(@getDOMNode(), @props.width, @props.height)
    paper = @paper
    raphaelLinks = @props.links.map (link) -> new Sembl.Games.Move.RaphaelLink(link)
    $.each(raphaelLinks, (i, l) -> l.render(paper))

  render: ->
    style = 
      position: 'absolute'
    `<div className="move__board__links" style={style}/>`


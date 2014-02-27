#= require d3
#= require raphael.js

###* @jsx React.DOM ###

class RaphaelLink
  constructor: (link) ->
    @source = 
      x: link.source().get("x")
      y: link.source().get("y")
    @target =
      x: link.target().get("x")
      y: link.target().get("y")

  render: (paper) ->
    lineFunction = d3.svg.diagonal()
    input = 
      source: @source
      target: @target
    path_data = lineFunction(input)
    paper.path(path_data)


Sembl.Games.Gameboard.LinksView = React.createClass
  componentDidMount: () -> 
    paper = Raphael(@getDOMNode(), @props.width, @props.height)
    @props.links.each (link) ->
      new RaphaelLink(link).render(paper)

  render: -> 
    return `<div className="board__links">
      </div>`


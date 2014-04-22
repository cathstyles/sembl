#= require d3
#= require raphael

###* @jsx React.DOM ###

Midpoint = React.createClass
  lineFunction: d3.svg.diagonal()
  render: ->
    {link, midpointFactory} = @props
    path = @lineFunction(link)
    length = Raphael.getTotalLength(path)
    midpoint = Raphael.getPointAtLength(path, length / 2)

    style = 
      left: midpoint.x
      top: midpoint.y

    `<div className="graph__midpoint" style={style}>
      {midpointFactory.createComponent(link)}
    </div>`

@Sembl.Components.Graph.Midpoints = React.createClass
  render: ->
    {links, midpointFactory} = @props
    midpoints = for link in @props.links
      `<Midpoint key={link.key} link={link} midpointFactory={midpointFactory} />`
        
    `<div className="graph__midpoints">
      {midpoints}
    </div>`
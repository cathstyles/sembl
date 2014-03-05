#= require d3
#= require raphael

###* @jsx React.DOM ###

Sembl.Components.Graph.Resemblances = React.createClass
  render: ->
    lineFunction = d3.svg.diagonal()
    sembls = for link in @props.links
      path = lineFunction(link)
      length = Raphael.getTotalLength(path)
      link.midpoint = Raphael.getPointAtLength(path, length / 2)
      style = 
        left: link.midpoint.x
        top: link.midpoint.y

      `<div key={link.model.id} className='graph__resemblance' style={style}>
        Sembl
      </div>`
    `<div className="graph__resemblances">
      {sembls}
    </div>`


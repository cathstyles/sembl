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

      filled = true
      emptySembl = 
      `<div className='graph__resemblance__empty'>
        unfilled
      </div>`

      filledSembl = 
        `<div className='graph__resemblance__filled'>
          filled
        </div>`

      `<div key={link.model.id} className='graph__resemblance' style={style}>
        {filled ? filledSembl : emptySembl}
      </div>`

    `<div className="graph__resemblances">
      {sembls}
    </div>`


#= require d3
#= require raphael

###* @jsx React.DOM ###

Sembl.Components.Graph.Resemblance = React.createClass
  lineFunction: d3.svg.diagonal()

  render: ->
    viewableResemblance = @props.viewableResemblance
    filled = !!viewableResemblance

    defaultChild = if filled
      `<div className='graph__resemblance__filled'>
        {filled ? viewableResemblance.description : 'filled'}
      </div>`
    else
      `<div className='graph__resemblance__empty'>
        unfilled
      </div>`

    child = this.props.children || defaultChild
    `<div key={link.model.id} className='graph__resemblance' style={style}>
      {child}
    </div>`

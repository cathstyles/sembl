#= require d3
#= require raphael

###* @jsx React.DOM ###

Sembl.Components.Graph.Resemblance = React.createClass
  handleClick: ->
    $(window).trigger('graph.resemblance.click', @props.link.model)

  lineFunction: d3.svg.diagonal()

  render: ->
    link = @props.link
    path = @lineFunction(link)
    length = Raphael.getTotalLength(path)
    link.midpoint = Raphael.getPointAtLength(path, length / 2)

    style = 
      left: link.midpoint.x
      top: link.midpoint.y

    viewableResemblance = link.model.get('viewable_resemblance')
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
    `<div key={link.model.id} className='graph__resemblance' style={style} onClick={this.handleClick}>
      {child}
    </div>`

Resemblance = Sembl.Components.Graph.Resemblance
Sembl.Components.Graph.Resemblances = React.createClass
  render: ->
    sembls = for link in @props.links
      if @props.childClasses.resemblance
        child = @props.childClasses.resemblance({link: link.model})
      `<Resemblance key={link.model.id} link={link}>
        {child}
      </Resemblance>`

    `<div className="graph__resemblances">
      {sembls}
    </div>`


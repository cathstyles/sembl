#= require d3
#= require raphael.js

###* @jsx React.DOM ###

Sembl.Games.Move.Resemblance = React.createClass

  render: ->
    link = @props.link
    lineFunction = d3.svg.diagonal()
    path_data = lineFunction(link)
    length = Raphael.getTotalLength(path_data)
    midpoint = Raphael.getPointAtLength(path_data, length / 2)

    style = 
      left: midpoint.x
      top: midpoint.y

    description = 'I am a sembl'

    `<div className='move__board__resemblance' style={style} >
      {description}
    </div>`

{Resemblance} = Sembl.Games.Move

Sembl.Games.Move.Resemblances = React.createClass
  render: ->
    resemblances = @props.links.map (link) ->
      `<Resemblance link={link} />`
    
    `<div>
      {resemblances}
    </div>`

    

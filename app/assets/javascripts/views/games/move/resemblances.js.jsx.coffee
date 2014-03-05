#= require d3
#= require raphael.js

###* @jsx React.DOM ###

Sembl.Games.Move.Resemblance = React.createClass
  getInitialState: ->
    filled: true

  render: ->
    link = @props.link
    lineFunction = d3.svg.diagonal()
    path_data = lineFunction(link)
    length = Raphael.getTotalLength(path_data)
    midpoint = Raphael.getPointAtLength(path_data, length / 2)

    style = 
      left: midpoint.x
      top: midpoint.y

    emptySembl = 
      `<div className='move__board__resemblance__empty'>
        Beep! I am empty
      </div>`

    filledSembl = 
      `<div className='move__board__resemblance__filled'>
        Honk! I am filled
      </div>`

    `<div className='move__board__resemblance' style={style} >
      {this.state.filled ? filledSembl : emptySembl}
    </div>`

{Resemblance} = Sembl.Games.Move

Sembl.Games.Move.Resemblances = React.createClass
  render: ->
    resemblances = @props.links.map (link) ->
      `<Resemblance key={link.source.id+'.'+link.target.id} link={link} />`
    
    `<div>
      {resemblances}
    </div>`

    

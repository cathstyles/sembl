
###* @jsx React.DOM ###

Sembl.Games.Move.Resemblance = React.createClass

  render: ->
    link = @props.link
    style = 
        left: @props.x
        top: @props.y

    `<div className='move__board__resemblance' style={style} >
      tag!
    </div>`


Sembl.Games.Move.Resemblances = React.createClass
  render: ->
    @props.links

    

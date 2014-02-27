#= require d3

###* @jsx React.DOM ###



Sembl.Games.Gameboard.LinksView = React.createClass
  componentDidMount: () -> 
    rootNode = @getDOMNode()
    canvas = rootNode.firstChild
    canvas.width = @props.width
    canvas.height = @props.height
    
    context = canvas.getContext("2d")
    context.clearRect(0, 0, @props.width, @props.height)
    context.beginPath()
    context.setLineWidth(2)
    context.setStrokeColor("#c77e1a")

    @props.links.each (link) ->
      context.moveTo(link.source().get("x"), link.source().get("y"))
      context.lineTo(link.target().get("x"), link.target().get("y"))
    context.stroke()

  render: -> 
    return `<div className="board__links">
        <canvas/>
      </div>`


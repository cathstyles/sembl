###* @jsx React.DOM ###

Sembl.GameNodesView = React.createBackboneClass 
  render: ->
    GameNodeView = Sembl.GameNodeView

    nodes = this.props.nodes.map((node) ->
      return `<GameNodeView key={node.get('id')} node={node} />`
    )
    return `<div className="board__nodes">
        {nodes}
      </div>`


Sembl.GameNodeView = React.createBackboneClass 
  render: ->
    style = 
      position: "absolute"
      left: this.props.node.get('x')
      top: this.props.node.get('y')

    return `<div className="board__node" style={style}>
      </div>`



# class Sembl.GameNodeView extends Backbone.View
#   className: "node"

#   events:
#     mouseover: "onMouseOver"
#     mouseout: "onMouseOut"
#     click: "onClick"

#   initialize: ->
#     @render()
#     @listenTo @model, "change:x change:y", =>
#       @$el.css(left: @model.get("x"), top: @model.get("y"))

#   render: ->
#     @$el.css(position: "absolute", left: @model.get("x"), top: @model.get("y"))

#   onMouseOver: ->
#     @$el.animate(width: 80, height: 80, margin: -40, 200)

#   onMouseOut: ->
#     @$el.animate(width: 60, height: 60, margin: -30, 200)

#   onClick: ->
#     @$el.css(backgroundColor: "#ccff00").animate(backgroundColor: "#c77e1a", 500)

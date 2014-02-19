###* @jsx React.DOM ###

Sembl.Gameboard.PlacementSummaryView = React.createClass 
  getImageForState: ->
    #TODO Add image urls for states 
    if @props.state is 'locked'
      return null
    else if @props.state is 'filled'
      return @props.placement.image_url
    else 
      if @props.placement
        return @props.placement.image_url
      else 
        return null
    

  render: ->
    className = "board__node__placement-summary state-#{@props.state}"
    imageUrl = @getImageForState()
    return `<div className={className} >
        <img src={imageUrl} />
      </div>`


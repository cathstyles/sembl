###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlacementSummaryView = React.createClass 
  getImageForState: ->
    #TODO Add image urls for states 
    if @props.state is 'locked'
      return null
    
    else if @props.state is 'filled' or @props.state is 'proposed'
      return @props.placement.image_thumb_url
    
    # Available
    else 
      return null
    
  handleClick: -> 
    Sembl.router.navigate("move/#{@props.node.id}", trigger: true)

  render: ->
    className = "board__node__placement-summary state-#{@props.state}"
    imageUrl = @getImageForState()
    return `<div className={className} onClick={this.handleClick}>
        <img src={imageUrl} />
      </div>`


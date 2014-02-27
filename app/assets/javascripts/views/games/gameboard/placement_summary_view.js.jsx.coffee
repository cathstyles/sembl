#= require jquery

###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlacementSummaryView = React.createClass 
  el: -> 
    @isMounted() && @getDOMNode()

  getImageForState: ->
    #TODO Add image urls for states 
    if @props.state is 'locked'
      null
    
    else if @props.state is 'filled' or @props.state is 'proposed'
      @props.placement.image_thumb_url
    
    # Available
    else 
      null
    
  toggleDetailView: -> 
    $(@el()).next().toggleClass('hidden')

  handleClick: -> 
    if @props.state is 'available'
      Sembl.router.navigate("move/#{@props.node.id}", trigger: true)
    else if @props.state is 'filled'
      @toggleDetailView()

  render: ->
    className = "board__node__placement-summary state-#{@props.state}"
    imageUrl = @getImageForState()
    
    `<div className={className} onClick={this.handleClick}>
        <img src={imageUrl} />
      </div>`


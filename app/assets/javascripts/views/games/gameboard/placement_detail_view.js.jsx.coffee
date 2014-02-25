###* @jsx React.DOM ###

Sembl.Games.Gameboard.PlacementDetailView = React.createClass 
  render: -> 
    className = "board__node__placement-detail"
    imageURL = @props.placement.image_url if @props.placement
    return `<div className={className}>
        <img src={imageURL} />
      </div>`
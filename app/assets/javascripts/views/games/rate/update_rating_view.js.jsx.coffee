#= require jquery
#= require simple-slider

###* @jsx React.DOM ###
@Sembl.Games.Rate.UpdateRatingView = React.createClass

  componentDidMount: -> 
    $el = $(@getDOMNode())
    $el.find('.rating__rate__slider').simpleSlider({highlight:'true'})

  render: ->
    `<div className="rating__rate">
      <input className="rating__rate__slider" type="text" />
    </div>`
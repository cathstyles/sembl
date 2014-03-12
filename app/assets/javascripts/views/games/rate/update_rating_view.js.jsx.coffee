#= require jquery
#= require simple-slider

###* @jsx React.DOM ###
@Sembl.Games.Rate.UpdateRatingView = React.createClass

  currentRating: -> 
    sembl = @props.link.get('viewable_resemblance')
    sembl?.rating 

  saveRating: (ratio) -> 
    sembl = @props.link.get('viewable_resemblance')
    data = rating: {resemblance_id: sembl.id, rating: ratio}
    $.post '/api/ratings', data, -> 
      console.log "saved rating"

  componentDidMount: -> 
    $el = $(@getDOMNode())
    slider = $el.find('input.rating__rate__slider') 
    slider.simpleSlider highlight: true
    
    _this = @
    slider.on "slider:changed", (event, data) ->
      _.throttle(_this.saveRating, data.ratio)

  render: ->
    `<div className="rating__rate">
      <input className="rating__rate__slider" type="text" value={this.currentRating}/>
    </div>`
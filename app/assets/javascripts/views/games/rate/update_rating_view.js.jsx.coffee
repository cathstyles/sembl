#= require jquery
#= require underscore
#= require simple-slider

###* @jsx React.DOM ###
@Sembl.Games.Rate.UpdateRatingView = React.createClass

  currentRating: -> 
    sembl = @props.link.get('viewable_resemblance')
    sembl?.rating 

  saveRating: (ratio) -> 
    sembl = @props.link.get('viewable_resemblance')
    data = 
      rating: {resemblance_id: sembl.id, rating: ratio}
      authenticity_token: @props.move.game.get('auth_token')

    $.post "#{@props.move.collection.url()}.json", data, -> 
      console.log "saved rating"

  componentDidMount: -> 
    $el = $(@getDOMNode())
    slider = $el.find('input.rating__rate__slider') 
    slider.simpleSlider highlight: true
    
    slider.simpleSlider("setRatio", @currentRating());
    saveRatingDebounced = _.debounce(@saveRating, 500)
    slider.on "slider:changed", (event, data) ->
      saveRatingDebounced(data.ratio)

  render: ->
    `<div className="rating__rate">
      <input className="rating__rate__slider" type="text"/>
    </div>`
#= require jquery
#= require underscore
#= require simple-slider

###* @jsx React.DOM ###
@Sembl.Games.Rate.UpdateRatingView = React.createClass

  currentResemblance: -> 
    @props.link.get('viewable_resemblance')

  currentRating: -> 
    sembl = @props.link.get('viewable_resemblance')
    sembl?.rating 

  saveRating: (ratio) -> 
    _this = @
    sembl = @props.link.get('viewable_resemblance')
    data = 
      rating: {resemblance_id: sembl.id, rating: ratio}
      authenticity_token: @props.move.game.get('auth_token')

    $.post "#{@props.move.collection.url()}.json", data, -> 
      sembl.rating = ratio
      link = _this.props.link.set('viewable_resemblance', sembl)
      _this.props.handleRated(link)

  componentDidMount: -> 
    $el = $(@getDOMNode())
    slider = $el.find('input.rating__rate__slider') 
    slider.simpleSlider highlight: true, range: [0, 1], step: 0.01
    
    saveRatingDebounced = _.debounce(@saveRating, 500)
    slider.on "slider:changed", (event, data) ->
      saveRatingDebounced(data.ratio)

  render: ->
    rating = @currentRating()
    `<div className="rating__rate">
      <input className="rating__rate__slider" type="text" defaultValue={rating} />
    </div>`
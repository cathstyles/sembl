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
    sembl = @props.link.get('viewable_resemblance')
    console.log sembl
    postData = 
      rating: {resemblance_id: sembl.id, rating: ratio}
      authenticity_token: @props.move.game.get('auth_token')

    result = $.post "#{@props.move.collection.url()}.json", postData, (data) => 
      sembl.rating = ratio
      link = @props.link.set('viewable_resemblance', sembl)
      @props.handleRated(link)

    result.fail (response) -> 
      responseObj = JSON.parse response.responseText;
      if response.status == 422 
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))   
      else
        $(window).trigger('flash.error', "Error rating: #{responseObj.errors}")

  componentDidMount: -> 
    $el = $(@getDOMNode())
    slider = $el.find('input.rating__rate__slider') 
    slider.simpleSlider highlight: true, range: [0, 1], step: 0.01
    
    saveRatingDebounced = _.debounce(@saveRating, 500)
    slider.on "slider:changed", (event, data) ->
      saveRatingDebounced(data.ratio)

  render: ->
    console.log @props.link
    rating = @currentRating() or 0
    `<div className="rating__rate">
      <input className="rating__rate__slider" type="text" defaultValue={rating} />
    </div>`
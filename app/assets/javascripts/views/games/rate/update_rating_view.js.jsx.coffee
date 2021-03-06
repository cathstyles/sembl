#= require jquery
#= require underscore
#= require jquery.nouislider.min

###* @jsx React.DOM ###
@Sembl.Games.Rate.UpdateRatingView = React.createClass

  currentResemblance: ->
    @props.link.get('viewable_resemblance')

  currentRating: ->
    sembl = @props.link.get('viewable_resemblance')
    sembl?.rating

  saveRating: (ratio) ->
    sembl = @props.link.get('viewable_resemblance')
    postData =
      rating: {resemblance_id: sembl.id, rating: ratio}
      authenticity_token: @props.move.game.get('auth_token')

    setData = =>
      sembl.rating = ratio
      link = @props.link.set('viewable_resemblance', sembl)
      @props.handleRated(link)

    result = $.post "#{@props.move.collection.url()}.json", postData, (data) =>
      setData()
      $(window).trigger('flash.notice', "Rating submitted")

    result.fail (response) ->
      responseObj = JSON.parse response.responseText;
      if response.status == 422
        msgs = (value for key, value of responseObj.errors)
        $(window).trigger('flash.error', msgs.join(", "))
      else
        $(window).trigger('flash.error', "Error rating: #{responseObj.errors}")

  componentDidMount: ->
    $el = $(@getDOMNode())
    slider = $el.find('.rating__rate__slider')
    slider.noUiSlider
      start: @currentRating()*100 || 50
      orientation: 'vertical'
      direction: 'rtl'
      range: 'min': 0, 'max': 100

    slider.on "set", =>
      @saveRating slider.val()/100

    # So we can drive the rating with Capybara
    ratingInput = $el.find('.rating__rate__input')
    ratingInput.on "change", =>
      @saveRating ratingInput.val()/100

    if @props.link.game.get('current_round') == 1
      $(window).trigger('Slide to rate this sembl!')


  render: ->
    `<div className="rating__rate">
      <input id="rating__rate__input" className="rating__rate__input hidden" type="text" value="50"/>
      <div className="rating__rate__slider" />
    </div>`

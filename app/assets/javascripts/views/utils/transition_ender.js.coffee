#= require jquery

#
#  new TransitionEnder($('.target'), function() { alert("done"); });
#
# You can also pass it a selector as the third argument to limit the descendants to a set of elements.

# new TransitionEnder(
#  $('.target’),
#  function() { alert("done"); },
#  “.elements-i-care-about"
# );


class @Sembl.Utils.TransitionEnder
  constructor: (@el, @callback, @descendantSelector = "*") ->
    @longestTime = @getElementTransitionTime(@el) || 0
    @longestElement = @el
    @getLongest()
    if @longestElement?
      safety = setTimeout(=>
        @callback()
        @longestElement.off "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd"
      , @longestTime);
      @longestElement.on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        clearTimeout safety
        @callback()
    else
      @callback()

  getLongest: ->
    descendants = @el.find(@descendantSelector)
    descendants.each (i) =>
      descendant = descendants.eq(i)
      total = @getElementTransitionTime descendant
      if total > @longestTime
        @longestTime = total
        @longestElement = descendant

  getElementTransitionTime: (element) ->
    duration = @parseSecondsToMilliseconds element.css("transitionDuration")
    delay = @parseSecondsToMilliseconds element.css("transitionDelay")
    return duration + delay

  parseSecondsToMilliseconds: (str) ->
    parseFloat(str) * 1000

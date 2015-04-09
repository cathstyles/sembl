#= require jquery

@Sembl.views.flashMessage = ($el, el) ->
  $el.on "click", "button", (e) ->
    e.preventDefault()
    $el.addClass "hidden"



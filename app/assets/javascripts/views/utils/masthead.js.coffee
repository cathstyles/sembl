#= require jquery

$ ->
  # Offset the header tab
  headingTabWidth = $('.heading h1').outerWidth()
  $('.heading h1').css 'margin-left', ((headingTabWidth / 2) * -1) + 'px'
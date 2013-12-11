#= stub jquery

Sembl.selectRandomSeed = ->
  
  
Sembl.selectSeedNode = -> 
  $suggestedSeeds = $('.suggested-seeds')
  $seedFormField = $('#seed_thing_id')
  $seedImage = $('.seed-image')

  $suggestedSeeds.on('click', '.seed', -> 
    $suggestedSeeds.find('.seed').removeClass('selected')
    $this = $(this)
    $this.addClass('selected')
    $seedFormField.val $this.data('id')
    $seedImage.html $this.html()
    $suggestedSeeds.hide()
  )

$ ->
  if $(document.body).is(".games-new, .games-edit")
    Sembl.selectSeedNode()
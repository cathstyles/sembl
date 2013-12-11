#= stub jquery

Sembl.selectSeedNode = -> 
  $suggestedSeeds = $('.suggested-seeds')
  $seedFormField = $('#seed_thing_id')

  $suggestedSeeds.on('click', '.seed', -> 
    $suggestedSeeds.find('.seed').removeClass('selected')
    $this = $(this)
    $this.addClass('selected')
    $seedFormField.val $this.data('id')
  )

$ ->
  if $(document.body).is(".games-new, .games-edit")
    Sembl.selectSeedNode()
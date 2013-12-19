#= stub jquery

Sembl.selectRandomSeed = ->
  $.ajax('/things/random').done (data) -> 
    $seedFormField = $('#seed_thing_id')
    $seedImage = $('.seed-image img')
    $seedFormField.val data.id
    $seedImage.attr('src', data.image_admin_url)
    $seedImage.attr('alt', data.title)


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

Sembl.updatePlayerFields = -> 
  
  $("#game_board_id").change ->
    players = parseInt($("#game_board_id option:selected").data('number_of_players'))
    invites = parseInt($(".invited_players .player_fields").size())
    $invited_players = $(".invited_players")
    console.log invites

    if players > invites
      new_fields = $('#new-player-fields').data('fields')
      
      [0..(players-invites)].each -> 
        $invited_players.append(new_fields)

    else if players < invites 
      #Remove player fields
      [0..(invites-players)].each -> 
        $invited_players.last()


$ ->
  if $(document.body).is(".games-new, .games-edit")
    Sembl.selectSeedNode()
    Sembl.updatePlayerFields()
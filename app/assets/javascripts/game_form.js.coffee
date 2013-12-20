#= stub jquery

Sembl.GameForm = {}

Sembl.GameForm.selectRandomSeed = ->
  $.ajax('/things/random').done (data) -> 
    $seedFormField = $('#seed_thing_id')
    $seedImage = $('.seed-image img')
    $seedFormField.val data.id
    $seedImage.attr('src', data.image_admin_url)
    $seedImage.attr('alt', data.title)


Sembl.GameForm.setupSeedNode = -> 
  $suggestedSeeds = $('.suggested-seeds')
  $seedFormField = $('#game_form_seed_thing_id')
  $seedImage = $('.seed-image')

  $suggestedSeeds.on('click', '.seed', -> 
    $suggestedSeeds.find('.seed').removeClass('selected')
    $this = $(this)
    $this.addClass('selected')
    $seedFormField.val $this.data('id')
    $seedImage.html $this.html()
    $suggestedSeeds.hide()
  )

Sembl.GameForm.setupPlayerFields = -> 
  $("#game_invite_only").change -> 
    console.log $(this).is(":checked")
    if $(this).is(":checked")
      $(".invited-players").show()
    else
      $(".invited-players").hide()

  $("#game_board_id").change ->
    players = parseInt($("#game_board_id option:selected").data('number_of_players'))
    invites = parseInt($(".invited-players .player-fields").size())
    invitesRemaining = players-invites

    if invitesRemaining > 0
      Sembl.GameForm.addInviteFields(invitesRemaining)
    else if invitesRemaining < 0
      Sembl.GameForm.destroyInviteFields(-invitesRemaining)
      

Sembl.GameForm.addInviteFields = (invitesRemaining) -> 
  $invitedPlayers =  $(".invited-players")
  newFields = $invitedPlayers.data('new')
  for n in [1..invitesRemaining]
    $invitedPlayers.append(newFields)

Sembl.GameForm.destroyInviteFields = (invitesToRemove) -> 
  $invitedPlayers =  $(".invited-players")
  destroyField = $invitedPlayers.data('destroy')
  $invitedPlayers.find('.player-fields').slice(-invitesToRemove).each (i, el) -> 
    $(el).append(destroyField)
    $(el).hide()

$ ->
  if $(document.body).is(".games-new, .games-edit")
    Sembl.GameForm.setupSeedNode()
    Sembl.GameForm.setupPlayerFields()
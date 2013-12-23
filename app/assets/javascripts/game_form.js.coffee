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

Sembl.GameForm.toggleInviteFields = -> 
  if $("#game_invite_only").is(":checked")
    $(".invited-players").show()
  else
    $(".invited-players").hide()

Sembl.GameForm.setupRequiredInviteFields = -> 
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
  time = new Date().getTime()
  for n in [1..invitesRemaining]
    regexp = new RegExp('new_player', 'g')
    $invitedPlayers.append(newFields.replace(regexp, time+n))

Sembl.GameForm.destroyInviteFields = (invitesToRemove) -> 
  $invitedPlayers =  $(".invited-players")
  $invitedPlayers.find('.player-fields').slice(-invitesToRemove).each (i, el) -> 
    $(el).find('.destroy-player').val(true)
    $(el).hide()

$ ->
  if $(document.body).is(".games-new, .games-edit, .games-create, .games-update")
    Sembl.GameForm.setupSeedNode()
    Sembl.GameForm.setupRequiredInviteFields()
    Sembl.GameForm.toggleInviteFields()

  $("#game_invite_only").change -> 
    Sembl.GameForm.toggleInviteFields()

  $("#game_board_id").change ->
    Sembl.GameForm.setupRequiredInviteFields()

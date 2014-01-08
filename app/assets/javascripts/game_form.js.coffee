#= stub jquery

class Sembl.GameForm
  constructor: ->
    @$invitedPlayers = $(".invited-players")
    @$seedFormField = $('#game_seed_thing_id')
    @$seedImage = $('.seed-image')
    @$gameInviteOnly = $('#game_invite_only')
    @$gameBoardId = $('#game_board_id')
    
    @setupSeedNode()

    if @$invitedPlayers.length
      @setupRequiredInviteFields()
    
    @toggleInviteFields()

    @$gameInviteOnly.change => 
      @toggleInviteFields()

    @$gameBoardId.change =>
      @setupRequiredInviteFields()


  selectRandomSeed: ->
    $.ajax('/things/random').done (data) => 
      @$seedFormField.val data.id
      @$seedImage.find('img').attr('src', data.image_admin_url)
      @$seedImage.find('img').attr('alt', data.title)


  setupSeedNode: -> 
    $suggestedSeeds = $('.suggested-seeds')
    self = this
    $suggestedSeeds.on('click', '.seed', -> 
      $suggestedSeeds.find('.seed').removeClass('selected')
      $this = $(this)
      $this.addClass('selected')
      self.$seedFormField.val $this.data('id')
      self.$seedImage.html $this.html()
      $suggestedSeeds.hide()
    )

  toggleInviteFields: -> 
    if @$gameInviteOnly.is(":checked")
      @$invitedPlayers.show()
      $('.game_uploads_allowed').show()
    else
      @$invitedPlayers.hide()
      $('.game_uploads_allowed').hide()

  setupRequiredInviteFields: -> 
    players = parseInt(@$gameBoardId.find("option:selected").data('number_of_players'))
    invites = parseInt(@$invitedPlayers.find(".player-fields").size())
    invitesRemaining = players-invites

    if invitesRemaining > 0
      @addInviteFields(invitesRemaining)
    else if invitesRemaining < 0
      @destroyInviteFields(-invitesRemaining)

  addInviteFields: (invitesRemaining) -> 
    newFields = @$invitedPlayers.data('new')
    time = new Date().getTime()
    for n in [1..invitesRemaining]
      regexp = new RegExp('new_player', 'g')
      @$invitedPlayers.append(newFields.replace(regexp, time+n))

  destroyInviteFields: (invitesToRemove) -> 
    @$invitedPlayers.find('.player-fields').slice(-invitesToRemove).each (i, el) -> 
      $(el).find('.destroy-player').val(true)
      $(el).hide()

$ ->
  if $(document.body).is(".games-new, .games-edit, .games-create, .games-update")
    Sembl.gameForm = new Sembl.GameForm

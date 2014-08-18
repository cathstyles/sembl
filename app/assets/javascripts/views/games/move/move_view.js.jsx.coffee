#= require d3
#= require views/components/searcher
#= require views/components/slide_viewer
#= require views/games/gallery
#= require views/games/move/actions
#= require views/games/move/gallery_thing_modal
#= require views/games/move/move_graph
#= require views/games/move/resemblance_modal
#= require views/components/slide_viewer
#= require views/components/thing_modal

###* @jsx React.DOM ###

{Actions, Board, MoveGraph, SelectedThing, GalleryThingModal, ResemblanceModal, PlacementModal} = Sembl.Games.Move
{Searcher, ThingModal, SlideViewer} = Sembl.Components
Gallery = @Sembl.Games.Gallery

@Sembl.Games.Move.MoveView = React.createClass
  searcherPrefix: 'move.searcher'
  galleryPrefix: 'move.gallery'

  componentWillMount: ->
    @$window = $(window)
    @$window.on('move.actions.submitMove', @handleSubmitMove)
    @$window.on('move.resemblance.change', @handleResemblanceChange)
    @$window.on("#{@galleryPrefix}.selectTargetThing", @handleSelectTargetThing)
    @$window.on("#{@galleryPrefix}.thing.click", @handleGalleryClick)
    @$window.on('move.resemblance.click', @handleResemblanceClick)
    @$window.on('move.placement.click', @handlePlacementClick)
    @$window.on('resize', @handleResize)

  componentWillUnmount: ->
    @$window.off('move.actions.submitMove', @handleSubmitMove)
    @$window.off('move.resemblance.change', @handleResemblanceChange)
    @$window.off("#{@galleryPrefix}.selectTargetThing", @handleSelectTargetThing)
    @$window.off("#{@galleryPrefix}.thing.click", @handleGalleryClick)
    @$window.off('move.resemblance.click', @handleResemblanceClick)
    @$window.off('move.placement.click', @handlePlacementClick)
    @$window.off('resize', @handleResize)
    @$window.trigger('slideViewer.hide')

  componentDidMount: ->
    @$window.trigger('slideViewer.setChild',
      `<Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />`
    )

    # Check turn is active
    player = @props.game.get('player')
    if player.state is "waiting"
      Sembl.router.navigate("", trigger: true)
      setTimeout(->
        $(window).trigger('flash.error', "Sorry, you’ve already ended your turn!")
      , 100)

  handleResize: ->
    @$window.trigger('graph.resize')

  handleResemblanceClick: (event, data) ->
    if @state.move.thing?
      link = data.link
      @$window.trigger('modal.open', `<ResemblanceModal description={data.description} target_description={data.target_description} source_description={data.source_description} link={link} targetThing={this.state.targetThing}/>`)

  handleResemblanceChange: (event, resemblance) ->
    resemblance.link.set('viewable_resemblance',
      description: resemblance.description
      target_description: resemblance.target_description
      source_description: resemblance.source_description
    )
    @state.move.addResemblance(resemblance.link, resemblance.description, resemblance.target_description, resemblance.source_description)
    self = @
    $.doTimeout('debounce.move.resemblance.change', 200, -> self.forceUpdate())

  handlePlacementClick: (event, data) ->
    if data.userState in ['proposed', 'available']
      @$window.trigger('slideViewer.show')
    else if data.thing
      @$window.trigger('modal.open', `<ThingModal thing={data.thing} />`)

  handleGalleryClick: (event, thing) ->
    @$window.trigger('modal.open', `<GalleryThingModal thing={thing} />`)

  handleSelectTargetThing: (event, thing) ->
    @$window.trigger('move.node.setThing', {node: @state.target, thing: thing})
    @$window.trigger('slideViewer.hide')
    @state.move.addPlacementThing(thing)
    @setState
      targetThing: thing
      move: @state.move

  handleSubmitMove: (event) ->
    @state.move.save({}, {
      success: =>
        @handleMoveComplete()
      error: (model, response) =>
        responseObj = JSON.parse response.responseText;

        if response.status == 422
          msgs = (value for key, value of responseObj.errors)
          @$window.trigger('flash.error', msgs.join(", "))
        else
          @$window.trigger('flash.error', "Error saving move: #{responseObj.errors}")
    })

  handleMoveComplete: () ->
    Sembl.game.fetch()
    Sembl.router.navigate("/", trigger: true)

  getInitialState: () ->
    target = @props.node
    links =
      for link in @props.game.links.where({target_id: target.id})
        _.extend({}, link)

    # We _always_ create a new move object
    move = new Sembl.Move({
      game: @props.game
      target_node: @props.node
    })

    # Basic state
    state =
      move: move
      target: target
      links: links

    # A move has been played already, we’re editing it
    existingPlacement = @props.node.get("viewable_placement")
    if existingPlacement? and existingPlacement.thing?
      move.addPlacementThing(existingPlacement.thing)
      # move.addResemblance(resemblance.link, resemblance.description, resemblance.target_description, resemblance.source_description)
      state.targetThing = existingPlacement.thing
    return state

  render: ->
    target = @state.target
    links = @state.links

    `<div className="move">
      <Searcher filter={this.props.game.get('filter')} prefix={this.searcherPrefix} game={this.props.game} />
      <div className="body-wrapper">
        <div className="body-wrapper__inner">
          <MoveGraph target={target} links={links} />
        </div>
      </div>
      <Actions move={this.state.move} game={this.props.game} />
    </div>`


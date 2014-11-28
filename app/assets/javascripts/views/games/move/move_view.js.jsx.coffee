#= require d3
#= require request_animation_frame
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
    @$window.on('slideViewer.show', @onSlideviewerShow)
    @$window.on('slideViewer.hide', @onSlideviewerHide)

  componentWillUnmount: ->
    @$window.off('move.actions.submitMove', @handleSubmitMove)
    @$window.off('move.resemblance.change', @handleResemblanceChange)
    @$window.off("#{@galleryPrefix}.selectTargetThing", @handleSelectTargetThing)
    @$window.off("#{@galleryPrefix}.thing.click", @handleGalleryClick)
    @$window.off('move.resemblance.click', @handleResemblanceClick)
    @$window.off('move.placement.click', @handlePlacementClick)
    @$window.off('resize', @handleResize)
    @$window.off('slideViewer.show', @onSlideviewerShow)
    @$window.off('slideViewer.hide', @onSlideviewerHide)

  componentDidMount: ->
    @$window.trigger('slideViewer.setChild',
      child: `<Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />`
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
      @$window.trigger('slideViewer.show', data)
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
    @$window.trigger('slideViewer.hide')
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

  onSlideviewerShow: (e, data) ->
    # Find the `.state-filled`
    offset = $(".state-filled").offset().top
    offset = offset - (offset * 0.15)
    @setState slideOffset: offset
    requestAnimationFrame => @$window.trigger "resize"

  onSlideviewerHide: (e) ->
    @setState slideOffset: 0
    requestAnimationFrame => @$window.trigger "resize"

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
      slideActive: false
      slideOffset: 0

    # A move has been played already, we’re editing it
    existingPlacement = @props.node.get("viewable_placement")
    if existingPlacement? and existingPlacement.thing?
      move.addPlacementThing(existingPlacement.thing)
      state.targetThing = existingPlacement.thing
    return state

  render: ->
    target = @state.target
    links = @state.links

    bodyOuterStyle =
      "-webkit-transform": "translate(0,-#{@state.slideOffset}px)"
      "-moz-transform": "translate(0,-#{@state.slideOffset}px)"
      "transform": "translate(0,-#{@state.slideOffset}px)"

    `<div className="move">
      <Searcher filter={this.props.game.get('filter')} prefix={this.searcherPrefix} game={this.props.game} />
      <div className="body-wrapper">
        <div className="body-wrapper__outer" style={bodyOuterStyle}>
          <div className="body-wrapper__inner">
            <MoveGraph target={target} links={links} />
          </div>
        </div>
      </div>
      <Actions move={this.state.move} game={this.props.game} />
    </div>`


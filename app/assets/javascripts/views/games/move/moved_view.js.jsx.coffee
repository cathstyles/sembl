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

@Sembl.Games.Move.MovedView = React.createClass
  componentWillMount: ->
    @$window = $(window)
    @$window.on('move.placement.click', @handlePlacementClick)
    @$window.on('resize', @handleResize)

  componentWillUnmount: ->
    @$window.off('move.placement.click', @handlePlacementClick)
    @$window.off('resize', @handleResize)

  handleResize: ->
    @$window.trigger('graph.resize')

  handlePlacementClick: (event, data) ->
    @$window.trigger('modal.open', `<ThingModal thing={data.thing} />`)

  getInitialState: () ->
    target = _.extend {}, @props.target
    source = @props.source

    target.set("user_state", "filled")

    links =
      for link in @props.game.links.where({source_id: source.id, target_id: target.id})
        _.extend({}, link)

    # Basic state
    state =
      target: target
      links: links

    return state

  render: ->
    target = @state.target
    links = @state.links

    bodyOuterStyle =
      "-webkit-transform": "translate(0,-#{@state.slideOffset}px)"
      "-moz-transform": "translate(0,-#{@state.slideOffset}px)"
      "transform": "translate(0,-#{@state.slideOffset}px)"

    creatorName = if @props.creator? && @props.creator.name? && @props.creator.name != ""
      @props.creator.name
    else if @props.creator?
      @props.creator.email
    else
      "..."
    creatorName = if @props.game.get("player")? && @props.game.get("player").user.id == @props.creator.id
      "you!"
    else
      creatorName

    `<div className="move">
      <div className="body-wrapper">
        <div className="body-wrapper__outer" style={bodyOuterStyle}>
          <div className="body-wrapper__inner">
            <MoveGraph target={target} links={links} />
          </div>
        </div>
        <div className="move__actions">
          <div className="move__actions-inner">
            <p>You’re viewing a move by {creatorName}</p>
            <a className="move__actions__button" href="#">Back to the game board</a>
          </div>
        </div>
      </div>
    </div>`


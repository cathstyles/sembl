#= require d3
#= require handlers/gallery_filter_handler
#= require views/components/graph/graph
#= require views/games/gallery
#= require views/games/header_view
#= require views/games/move/actions
#= require views/games/move/gallery_thing_modal
#= require views/games/move/node
#= require views/games/move/resemblance
#= require views/games/move/selected_thing
#= require views/layouts/default

###* @jsx React.DOM ###

{Actions, Board, Node, Resemblance, SelectedThing, GalleryThingModal, PlacementModal} = Sembl.Games.Move
{Gallery, HeaderView} = Sembl.Games
Layout = Sembl.Layouts.Default
Graph = Sembl.Components.Graph.Graph

@Sembl.Games.Move.MoveView = React.createClass
  componentWillMount: ->
    @galleryFilterHandler = new Sembl.Handlers.GalleryFilterHandler(@props.game.get('filter'))
    @galleryFilterHandler.bind()
    $(window).on('move.actions.submitMove', @handleSubmitMove)
    $(window).on('move.resemblance.change', @handleResemblanceChange)
    $(window).on('move.gallery.selectTargetThing', @handleSelectTargetThing)
    $(window).on('gallery.thing.click', @handleGalleryClick)
    $(window).on('gallery.thing.click', @handleGalleryClick)
    
  componentDidMount: ->
    @galleryFilterHandler.handleSearch()

  componentWillUnmount: ->
    @galleryFilterHandler.unbind()
    $(window).off('move.actions.submitMove')
    $(window).off('move.resemblance.change')
    $(window).off('move.gallery.selectTargetThing')
    $(window).off('gallery.thing.click')

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.description
      resemblance.link.set('viewable_resemblance',
        {
          description: resemblance.description
        }
      )
      @state.move.addResemblance(resemblance.link, resemblance.description)
  
  handleGalleryClick: (event, thing) ->
    $(window).trigger('modal.open', `<GalleryThingModal thing={thing} />`)

  handleSelectTargetThing: (event, thing) ->
    $(window).trigger('move.node.setThing', {node: @state.target, thing: thing})
    @state.move.addPlacementThing(thing)
    @setState
      move: @state.move

  handleSubmitMove: (event) ->
    Sembl.move = @state.move
    self = this
    @state.move.save({}, {
      success: -> 
        self.handleMoveComplete()
      error: (model, response) -> 
        responseObj = JSON.parse response.responseText;
        
        if response.status == 422 
          msgs = (value for key, value of responseObj.errors)
          $(window).trigger('flash.error', msgs.join(", "))   
        else
          $(window).trigger('flash.error', "Error saving move: #{responseObj.errors}")
    })

  handleMoveComplete: () ->
    Sembl.game.fetch()
    Sembl.router.navigate("/", trigger: true)

  getInitialState: () ->
    target = @props.node
    links = 
      for link in @props.game.links.where({target_id: target.id})
        _.extend({}, link)
    move = new Sembl.Move({
      game: @props.game
      target_node: @props.node
    })

    state =
      move: move
      target: target
      links: links
      editResemblance: null

  render: -> 
    target = @state.target
    links = @state.links
    sources = (link.source() for link in links)

    rootNode = _.extend({children: sources}, target)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)

    header = `<HeaderView game={this.props.game} >
      Your Move
    </HeaderView>`

    graphChildClasses = {
      node: Node
      resemblance: Resemblance
    }

    `<Layout className="game" header={header}>
      <div className="move">
        <div className="move__graph">
          <Graph nodes={nodes} links={links} childClasses={graphChildClasses}/>
        </div>
        <Actions />
        <Gallery SelectedClass={SelectedThing} />
      </div>
    </Layout>`


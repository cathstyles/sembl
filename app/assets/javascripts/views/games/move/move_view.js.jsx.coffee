#= require d3
#= require handlers/gallery_filter_handler
#= require views/components/graph/graph
#= require views/games/gallery
#= require views/games/header_view
#= require views/games/move/actions
#= require views/games/move/resemblance
#= require views/games/move/selected_thing
#= require views/layouts/default

###* @jsx React.DOM ###

{Actions, Board, Resemblance, SelectedThing} = Sembl.Games.Move
{Gallery, HeaderView} = Sembl.Games
Layout = Sembl.Layouts.Default
Graph = Sembl.Components.Graph.Graph

@Sembl.Games.Move.MoveView = React.createClass
  componentWillMount: ->
    @galleryFilterHandler = new Sembl.Handlers.GalleryFilterHandler(@props.game.get('filter'))
    @galleryFilterHandler.bind()
    $(window).on('graph.node.click', @handleNodeClick)
    $(window).on('graph.resemblance.click', @handleResemblanceClick)
    $(window).on('move.actions.submitMove', @handleSubmitMove)
    $(window).on('move.resemblance.change', @handleResemblanceChange)
    $(window).on('move.gallery.selectTargetThing', @handleSelectTargetThing)
    
  componentDidMount: ->
    @galleryFilterHandler.handleSearch()

  componentWillUnmount: ->
    @galleryFilterHandler.unbind()
    $(window).off('graph.node.click')
    $(window).off('graph.resemblance.click')
    $(window).off('move.actions.submitMove')
    $(window).off('move.resemblance.change')
    $(window).off('move.gallery.selectTargetThing')

  handleNodeClick: (event, node) ->
    userState = node.get('user_state')
    if userState == 'available'
      console.log 'selected available'

  handleResemblanceChange: (event, resemblance) ->
    if resemblance.description
      resemblance.link.set('viewable_resemblance', 
        {
          description: resemblance.description
        }
      )
      @state.move.addResemblance(resemblance.link, resemblance.description)
    
  handleEditResemblanceClose: () ->
    @setState
      editResemblance: null

  handleSelectTargetThing: (event, thing) ->
    target = @state.target
    targetThing = thing
    viewablePlacement = 
      image_thumb_url: thing.image_admin_url
      image_url: thing.image_browse_url
      title: thing.title
    target.set('viewable_placement', 
      viewablePlacement
    )
    target.set('user_state', 'proposed')

    @state.move.addPlacementThing(targetThing)
    @setState
      target: target

  handleSubmitMove: () ->
    console.log 'Submitting move', JSON.stringify(@state.move)
    url = "/api/moves.json"
    Sembl.move = @state.move
    @state.move.save()

  getInitialState: () ->
    target = _.extend({}, @props.node)
    links = 
      for link in @props.game.links.where({target_id: target.id})
        _.extend({}, link)
    move = new Sembl.Move({
      game: @props.game
      targetNode: @props.node
    })

    state =
      move: move
      target: target
      links: links
      editResemblance: null

  render: -> 
    move = new Sembl.Move({
      game: @props.game
      node: @props.node, 
      thing: null,
      resemblances: []
    })
    Sembl.move = move

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


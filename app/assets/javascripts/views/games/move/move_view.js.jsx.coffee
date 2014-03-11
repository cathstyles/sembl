#= require d3
#= require handlers/gallery_filter_handler
#= require views/components/graph/graph
#= require views/games/gallery
#= require views/games/header_view
#= require views/games/move/actions
#= require views/games/move/edit_resemblance
#= require views/games/move/selected_thing
#= require views/layouts/default

###* @jsx React.DOM ###

{Actions, Board, EditResemblance, SelectedThing} = Sembl.Games.Move
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
    $(window).on('move.editResemblance.change', @handleEditResemblanceChange)
    $(window).on('move.editResemblance.close', @handleEditResemblanceClose)
    $(window).on('move.gallery.selectTargetThing', @handleSelectTargetThing)
    
  componentDidMount: ->
    @galleryFilterHandler.handleSearch()

  componentWillUnmount: ->
    @galleryFilterHandler.unbind()
    $(window).off('graph.node.click')
    $(window).off('graph.resemblance.click')
    $(window).off('move.actions.submitMove')
    $(window).off('move.editResemblance.change')
    $(window).off('move.editResemblance.close')
    $(window).off('move.gallery.selectTargetThing')

  handleNodeClick: (event, node) ->
    userState = node.get('user_state')
    if userState == 'available'
      console.log 'selected available'

  handleResemblanceClick: (event, link) ->
    console.log 'clicked on sembl', link
    @setState
      editResemblance:
        link: link

  handleEditResemblanceChange: (event, resemblance) ->
    if resemblance.description
      resemblance.link.set('viewable_resemblance', 
        {
          description: resemblance.description
        }
      )
    else
      resemblance.link.set('viewable_placement', null)

    @state.move.addResemblance(resemblance.link, resemblance.description)
    @setState
      links: this.state.links


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

    editResemblanceModal = if @state.editResemblance
      `<EditResemblance link={this.state.editResemblance.link} />`

    `<Layout className="game" header={header}>
      <div className="move">
        <Graph nodes={nodes} links={links} />
        {editResemblanceModal}
        <Actions />
        <Gallery SelectedClass={SelectedThing} />
      </div>
    </Layout>`


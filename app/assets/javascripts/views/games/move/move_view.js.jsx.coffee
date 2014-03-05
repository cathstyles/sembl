#= require views/games/move/actions
#= require views/games/move/board
#= require views/games/move/selected_thing
#= require views/layouts/default
#= require views/games/gallery
#= require handlers/gallery_filter_handler

###* @jsx React.DOM ###

{Actions, Board, SelectedThing} = Sembl.Games.Move
{Gallery} = Sembl.Games
Layout = Sembl.Layouts.Default

@Sembl.Games.Move.MoveView = React.createClass

  componentWillMount: ->
    @galleryFilterHandler = new Sembl.Handlers.GalleryFilterHandler(@props.game.get('filter'))
    @galleryFilterHandler.bind()

  componentDidMount: ->
    @galleryFilterHandler.handleSearch()

  componentWillUnmount: ->
    @galleryFilterHandler.unbind()

  handleSubmitMove: () ->
    params = {move: this.state.move}
    console.log params
    url = "/api/moves.json"
    # TODO: this should be POST, but get is helpful for debugging.
    $.get(
      url
      params,
      (move_status) ->
        console.log move_status
      "json"
    )

  render: -> 
    move = new Sembl.Move({
      node: @props.node, 
      thing: null,
      resemblances: []
    })

    game = @props.game
    targetNode = @props.node
    sourceNodes = game.links.where({target_id: targetNode.id}).map (link) -> link.source()

    
    rootNode = _.extend({children: sourceNodes}, targetNode)
    tree = d3.layout.tree()
    nodes = tree.nodes(rootNode)
    links = tree.links(nodes)
    filter = @props.game.filter

    `<Layout>
      <div className="move">
        <Board nodes={nodes} links={links} />
        <Actions />
        <Gallery SelectedClass={SelectedThing} />
      </div>
    </Layout>`
#= require d3
#= require views/components/graph/graph
#= require views/components/searcher
#= require views/games/gallery
#= require views/games/move/actions
#= require views/games/move/gallery_thing_modal
#= require views/games/move/node
#= require views/games/move/resemblance
#= require views/games/move/resemblance_modal

###* @jsx React.DOM ###

{Actions, Board, Node, Resemblance, SelectedThing, GalleryThingModal, ResemblanceModal, PlacementModal} = Sembl.Games.Move
Graph = Sembl.Components.Graph.Graph
{Searcher} = Sembl.Components
Gallery = @Sembl.Games.Gallery

@Sembl.Games.Move.MoveView = React.createClass
  searcherPrefix: 'move.searcher'
  galleryPrefix: 'move.gallery'

  componentWillMount: ->
    $(window).on('move.actions.submitMove', @handleSubmitMove)
    $(window).on('move.resemblance.change', @handleResemblanceChange)
    $(window).on("#{@galleryPrefix}.selectTargetThing", @handleSelectTargetThing)
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryClick)
    $(window).on('move.resemblance.click', @handleResemblanceClick)
    $(window).on('resize', @handleResize)

  componentWillUnmount: ->
    $(window).off('move.actions.submitMove')
    $(window).off('move.resemblance.change')
    $(window).off("#{@galleryPrefix}.selectTargetThing")
    $(window).off("#{@galleryPrefix}.thing.click")
    $(window).off('move.resemblance.click')
    $(window).off('resize')

  handleResize: ->
    $(window).trigger('graph.resize')

  handleResemblanceClick: (event, data) ->
    link = data.link
    $(window).trigger('modal.open', `<ResemblanceModal description={data.description} link={link} targetThing={this.state.targetThing}/>`)

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
      targetThing: thing
      move: @state.move

  handleSubmitMove: (event) ->
    Sembl.move = @state.move
    self = this
    @state.move.save({}, {
      success: -> 
        self.handleMoveComplete()
        # $(window).trigger('flash.notice', "Move submitted!")
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

    graphChildClasses = {
      node: Node
      resemblance: Resemblance
    }

    `<div className="move">
      <Searcher filter={this.props.game.get('filter')} prefix={this.searcherPrefix} />
      <div className="move__graph">
        <Graph nodes={nodes} links={links} childClasses={graphChildClasses}/>
      </div>
      <Actions />
        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
    </div>`


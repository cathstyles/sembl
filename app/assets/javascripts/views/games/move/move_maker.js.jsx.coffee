#= require views/games/move/nodes_view 

###* @jsx React.DOM ###
{NodesView, LinksView} = @Sembl.Games.Move

@Sembl.Games.Move.MoveMaker = React.createBackboneClass
  className: "move__move-maker"

  handleSubmitMove: () ->
    params = {move: this.state.move}
    console.log params
    url = "/api/moves.json"
    # TODO: this shoudl be POST, but get is helpful for debugging.
    $.get(
      url
      params,
      (move_status) ->
        console.log move_status
      "json"
    )

  handleSelectThing: (thing) ->
    @model().set('thing', thing)

  render: () ->
    `<div className={this.className}>
      <NodesView node={this.props.node} />
      
      <button onClick={this.handleSubmitMove}>Submit Move</button>
    </div>`
    

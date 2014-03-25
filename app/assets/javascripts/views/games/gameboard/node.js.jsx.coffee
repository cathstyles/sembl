#= require views/components/graph/node
#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Node} = Sembl.Components.Graph

@Sembl.Games.Gameboard.Node = React.createClass
  handleClick: (event, data) ->
    node = @props.node
    userState = node.get('user_state')
    if userState == 'available'
      Sembl.router.navigate("move/#{node.id}", trigger: true)
    else
      thing = node.get('viewable_placement')?.thing
      if thing
        $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  render: () ->
    `<div onClick={this.handleClick}>
      <Node node={this.props.node} />
    </div>`


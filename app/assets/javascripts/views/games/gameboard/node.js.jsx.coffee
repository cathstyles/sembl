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
    round = @props.node.game.get('current_round') 
    userState = @props.node.get('user_state')
    tooltip = if round == 1 and userState == 'available'
      `<Tooltip className="graph__node__tooltip">
        Let's go! Add your first image to begin the game. 
      </Tooltip>`

    `<div onClick={this.handleClick}>
      <Node node={this.props.node} />
      {tooltip}
    </div>`


#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{GameNode} = Sembl.Components.Graph

@Sembl.Games.Gameboard.Placement = React.createClass
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
    node = @props.node
    userState = @props.userState || node.get('user_state')
    className = "game__placement state-#{userState}"
    
    thing = node.get('viewable_placement')?.thing
    image_url = @props.image_url || thing?.image_admin_url

    `<div className={className} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
    </div>`



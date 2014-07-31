#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Node} = Sembl.Components.Graph

@Sembl.Games.Rate.Placement = React.createClass
  handleClick: (event, data) ->
    thing = @props.node.get('viewable_placement')?.thing
    if thing
      $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  render: () ->
    userState = @props.node.get('user_state')
    className = "game__placement state-#{userState}"
    thing = @props.node.get('viewable_placement')?.thing
    image_url = thing?.image_admin_url

    # Format the sub-description
    subDescription = @props.node.get("sub_description")
    subDescriptionNode = if subDescription?
      `<div className="game__placement__sub-description">{subDescription}</div>`
    else
      ""


    `<div className={className} onClick={this.handleClick}>
      <img className="game__placement__image" src={image_url} />
      {subDescriptionNode}
    </div>`

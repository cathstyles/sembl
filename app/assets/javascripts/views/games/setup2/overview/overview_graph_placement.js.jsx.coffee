#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components

@Sembl.Games.Setup.OverviewGraphPlacement = React.createClass
  handleClick: (event, data) ->
    if @props.thing
      $(window).trigger('modal.open', `<ThingModal thing={this.props.thing} />`)

  render: () ->
    userState = if @props.thing then 'state' else 'locked'
    className = "game__placement state-#{userState}"
    image_url = @props.thing?.image_admin_url

    `<div className={className} onClick={this.handleClick}>
      <div className="setup__overview__graph__placement__round">Round {this.props.round}</div>
      <img className="game__placement__image" src={image_url} />
    </div>`




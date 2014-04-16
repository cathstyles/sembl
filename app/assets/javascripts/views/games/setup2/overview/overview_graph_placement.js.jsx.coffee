#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components

@Sembl.Games.Setup.OverviewGraphPlacement = React.createClass
  handleClick: (event, data) ->
    if @props.thing
      if this.props.isDraft
        $(window).trigger('setup.steps.add', {stepName: 'seed'})
      else 
        $(window).trigger('modal.open', `<ThingModal thing={this.props.thing}/>`)

  render: () ->
    userState = 
      if @props.thing 
        'filled'
      else
        if @props.round == 0
          'available'
        else
          'locked'

    className = "game__placement state-#{userState}"
    image_url = @props.thing?.image_admin_url

    roundText = if this.props.round == 0
        "Seed"
      else
        "Round #{this.props.round}"

    `<div className={className} onClick={this.handleClick}>
      <div className="setup__overview__graph__placement__round">{roundText}</div>
      <img className="game__placement__image" src={image_url} />
    </div>`


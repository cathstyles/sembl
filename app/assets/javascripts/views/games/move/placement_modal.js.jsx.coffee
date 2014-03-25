#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components

@Sembl.Games.Move.PlacementModal = React.createClass
  render: () ->
    thing = @props.thing
    `<ThingModal thing={thing}>
    </ThingModal>`

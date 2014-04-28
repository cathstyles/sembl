#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
@Sembl.Games.Setup.StepSeedThingModal = React.createClass
  handleSelectSeed: ->
    $(window).trigger(@props.selectEvent, @props.thing)
    $(window).trigger("modal.close")
    event.preventDefault()

  render: ->
    thing = @props.thing
    `<ThingModal thing={thing}>
      <a onClick={this.handleSelectSeed} className="games__setup__selected_thing-set-as-seed-node" href="#"><i className="fa fa-check"></i> <em>Set as seed node</em></a>
    </ThingModal>`

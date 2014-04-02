#= require views/components/thing_modal
#= require views/components/toggle_component

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
@Sembl.Games.Setup.GalleryThingModal = React.createClass
  className: "games__setup__gallery-thing-modal"

  handleSelectSeed: ->
    $(window).trigger('setup.seed.select', @props.thing)
    $(window).trigger('modal.close')
    event.preventDefault()

  render: ->
    thing = @props.thing
    
    `<ThingModal thing={thing}>
      <a onClick={this.handleSelectSeed} className="games__setup__selected_thing-set-as-seed-node" href="#"><i className="fa fa-check"></i> <em>Set as seed node</em></a>
      <em className="games__setup__selected_thing-or">Or</em>
      <a className="games__setup__selected_thing-exclude-from-game" href="#"><i className="fa fa-times"></i> <em>Exclude from game</em></a>
    </ThingModal>`

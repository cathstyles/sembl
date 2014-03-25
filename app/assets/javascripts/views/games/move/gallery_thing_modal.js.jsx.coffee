#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components

@Sembl.Games.Move.GalleryThingModal = React.createClass
  handlePlaceThing: ->
    $(window).trigger('move.gallery.selectTargetThing', @props.thing)
    $(window).trigger('modal.close')

  render: () ->
    thing = @props.thing
    `<ThingModal thing={thing}>
      <button className='move__thing-modal__place-button'onClick={this.handlePlaceThing}>
        <i className='fa fa-picture-o'></i> Place image
      </button>
    </ThingModal>`

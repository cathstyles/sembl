###* @jsx React.DOM ###

@Sembl.Games.Move.SelectedThing = React.createClass

  handleSelectThing: (event) ->
    $(window).trigger('move.gallery.selectTargetThing', @props.thing)
    $(window).trigger(@props.toggleEvent, {flag: off})
    event.preventDefault()

  render: () ->
    thing = this.props.thing

    `<div className='move__gallery__selected'>
      <h1 className='move__gallery__selected-heading'>&ldquo;{thing.title}&rdquo;</h1>
      <button onClick={this.handleSelectThing} className='move__gallery__selected-button'><i className='fa fa-picture-o'></i> Place image</button>
    </div>`
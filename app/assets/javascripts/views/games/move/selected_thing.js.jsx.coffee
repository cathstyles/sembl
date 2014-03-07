###* @jsx React.DOM ###

@Sembl.Games.Move.SelectedThing = React.createClass

  handleSelectThing: (event) ->
    $(window).trigger('move.gallery.selectTargetThing', @props.thing)
    event.preventDefault()

  render: () ->
    thing = this.props.thing

    `<div className='move__gallery__selected'>
      <button onClick={this.handleSelectThing}>Place "{thing.title}"</button>
    </div>`
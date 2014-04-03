#= require views/games/gallery
#= require views/components/toggle_component
#= require views/components/thing_modal

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
@Sembl.Games.Setup.SeedFocus = React.createClass
  className: "games__setup__seed__focus"

  handleSelectSeed: ->
    $(window).trigger('setup.seed.select', @props.thing)
    $(window).trigger('modal.close')
    event.preventDefault()

  render: ->
    thing = @props.thing
    `<ThingModal thing={thing}>
      <a onClick={this.handleSelectSeed} className="games__setup__selected_thing-set-as-seed-node" href="#"><i className="fa fa-check"></i> <em>Set as seed node</em></a>
    </ThingModal>`

{ToggleComponent} = @Sembl.Components
{Gallery} = @Sembl.Games
{SeedFocus} = @Sembl.Games.Setup
@Sembl.Games.Setup.SeedModal = React.createClass
  componentWillMount: ->
    $(window).on('setup.seed.gallery.thing.click', @handleFocusSeed)

  componentWillUnmount: ->
    $(window).off('setup.seed.gallery.thing.click')

  componentDidMount: ->
    $(window).trigger('setup.seed.searcher.notify')

  getInitialState: ->
    focusThing: null

  handleFocusSeed: (event, thing) ->
    @setState
      focusThing: thing
    $(window).trigger('setup.seed.modal.toggle')

  render: ->
    component = ToggleComponent
      OffClass: `<Gallery searcherPrefix="setup.seed.searcher" eventPrefix="setup.seed.gallery" />`
      OnClass: `<SeedFocus thing={this.state.focusThing} />`
      toggleEvent: 'setup.seed.modal.toggle'

    `<div className="setup__seed__modal">
      {component}
    </div>`
    

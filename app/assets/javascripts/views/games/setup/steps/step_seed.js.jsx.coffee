#= require views/games/setup/steps/step_seed_thing_modal
#= require views/components/searcher
#= require views/games/gallery

###* @jsx React.DOM ###


Checkbox = React.createClass
  handleChange: (event) ->
    @props.handleChange(@props.name, event.target.checked)

  render: () ->
    checked = this.props.checked || false
    className = "setup__steps__seed__#{@props.name}"
    `<div className={className}>
      <label>
        {this.props.label}      
        <input type="checkbox" checked={checked} onChange={this.handleChange} />
      </label>
    </div>`

{StepSeedThingModal} = Sembl.Games.Setup
{Searcher} = Sembl.Components
{Gallery} = Sembl.Games

@Sembl.Games.Setup.StepSeed = React.createClass
  galleryPrefix: "setup.steps.seed.gallery"

  componentWillMount: ->
    $(window).on('setup.steps.seed.select', @handleSeedSelect)
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryClick)

  componentWillUnmount: ->
    $(window).trigger('slideViewer.hide')
    $(window).off('setup.steps.seed.select', @handleSeedSelect)
    $(window).off("#{@galleryPrefix}.thing.click", @handleGalleryClick)

  componentDidMount: ->
    @setSlideViewer()    

  setSlideViewer: ->
    seed = @props.seed
    suggested_seed = @state.suggested_seed
    $(window).trigger('slideViewer.setChild', 
      `<div>
        <div className="slide-viewer__controls">
          <Checkbox name='suggested_seed' checked={suggested_seed} label="Suggested seeds" handleChange={this.handleCheckboxChange} />
        </div>
        <Gallery searcherPrefix={this.props.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>`
    )

  handleCheckboxChange: (name, value) ->
    @state[name] = value
    @setState @state
    filter = _.extend({}, @props.filter)
    filter[name] = 1 if value == true   
    @setSlideViewer() 
    $(window).trigger("#{this.props.searcherPrefix}.setFilter", filter)

  handleGalleryClick: (event, thing) ->
    $(window).trigger('modal.open', `<StepSeedThingModal selectEvent='setup.steps.seed.select' thing={thing} />`)

  handleSeedSelect: (event, thing) ->
    $(window).trigger('slideViewer.hide')
    $(window).trigger('setup.steps.change', {seed: thing})

  handleSeedClick: (event) ->
    $(window).trigger('slideViewer.show')

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/api/things/random.json", {}, (thing) ->
      self.handleSeedSelect({}, thing);
    )
    event?.preventDefault()

  isValid: -> @props.seed? && @props.seed.id?

  getInitialState: ->
    suggested_seed: false

  render: ->
    seed = @props.seed
    image_url = seed?.image_admin_url
    seedPlacementClassName = if seed?.id
      "game__placement state-filled"
    else 
      "game__placement state-available"

    `<div className="setup__steps__seed">
      <div className="setup__steps__title">Choose a seed:</div>
      <div className="setup__steps__inner">
        <div className={seedPlacementClassName} onClick={this.handleSeedClick}>
          <img className="game__placement__image" key={image_url} src={image_url} />
        </div>
        <h3 className="setup__steps__seed-randomise">
          <a href="#" onClick={this.handleRandomSeed}><i className="fa fa-random"></i>&nbsp;<em>Randomise</em></a>
        </h3>
      </div>
    </div>`

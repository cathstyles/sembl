#= require views/games/setup/steps/step_seed_thing_modal
#= require views/components/searcher
#= require views/games/gallery

###* @jsx React.DOM ###

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
    seed = @props.seed
    $(window).trigger('slideViewer.setChild', 
      `<Gallery searcherPrefix={this.props.searcherPrefix} eventPrefix={this.galleryPrefix} />`
    )

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

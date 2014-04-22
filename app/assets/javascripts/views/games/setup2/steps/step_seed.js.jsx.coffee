#= require views/games/setup2/steps/step_seed_gallery
#= require views/components/searcher

###* @jsx React.DOM ###

{StepSeedGallery} = Sembl.Games.Setup
{Searcher} = Sembl.Components

@Sembl.Games.Setup.StepSeed = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.seed.select', @handleSeedSelect)

  componentWillUnmount: ->
    $(window).off('setup.steps.seed.select')

  componentDidMount: ->
    seed = @props.seed

  handleSeedSelect: (event, thing) ->
    $(window).trigger('setup.steps.change', {seed: thing})

  handleSeedClick: (event) ->
    $(window).trigger('modal.open', `<StepSeedGallery prefix="setup.steps.seed" />`)

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/api/things/random.json", {}, (thing) ->
      self.handleSeedSelect({}, thing);
    )
    event?.preventDefault()

  isValid: -> @props.seed?

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
        <Searcher prefix="setup.steps.seed.searcher" />
      </div>
    </div>`

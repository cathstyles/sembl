#= require views/games/setup2/seed_gallery
#= require views/components/searcher

###* @jsx React.DOM ###

{SeedModal} = Sembl.Games.Setup
{Searcher} = Sembl.Components

@Sembl.Games.Setup.StepSeed = React.createClass
  componentWillMount: ->
    $(window).on('setup.steps.seed.select', @handleSeedSelect)

  componentWillUnount: ->
    $(window).off('setup.steps.seed.select')

  componentDidMount: ->
    seed = @props.seed
    if seed?
      self = this
      $.getJSON("/api/things/"+ seed.id+".json", {}, (thing) ->
        self.handleSeedSelect({}, thing);
      )

  handleSeedSelect: (event, thing) ->
    $(window).trigger('setup.steps.change', {seed: thing})

  handleSeedClick: (event) ->
    $(window).trigger('modal.open', `<SeedModal prefix="setup.steps.seed" />`)

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/api/things/random.json", {}, (thing) ->
      self.handleSeedSelect({}, thing);
    )
    event?.preventDefault()

  render: ->
    seed = @props.seed
    image_url = seed?.image_admin_url || "http://placehold.it/120x120"
    `<div className="setup__steps__seed">
      <h3 className="setup__steps__seed-title">Choose a seed node</h3>
      <img className="setup__steps__seed-image"
        key={image_url}
        src={image_url}
        width="120" height="120" 
        onClick={this.handleSeedClick} />
      <h3 className="setup__steps__seed-randomise">
        <a href="#" onClick={this.handleRandomSeed}><i className="fa fa-random"></i> <span>Randomise</span></a>
      </h3>
      <Searcher prefix="setup.steps.seed.searcher" />
    </div>`

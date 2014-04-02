#= require views/games/setup/seed_gallery_modal
#= require views/components/searcher

###* @jsx React.DOM ###

{SeedModal} = Sembl.Games.Setup
{Searcher} = Sembl.Components

@Sembl.Games.Setup.Seed = React.createClass
  className: "games-setup__seed"

  getInitialState: ->
    id: this.props.seed.id
    title: this.props.seed.title || ""
    image_url: this.props.seed.image_admin_url || "http://placehold.it/120x120"

  componentWillMount: ->
    $(window).on('setup.seed.select', @handleSeedSelect)

  componentWillUnount: ->
    $(window).off('setup.seed.select')

  componentDidMount: ->
    if @state.id
      self = this
      $.getJSON("/api/things/"+ this.state.id+".json", {}, (thing) ->
        self.handleSeedSelect({}, thing);
      )

  handleSeedSelect: (event, thing) ->
    this.setState
      id: thing.id
      title: thing.title
      image_url: thing.image_admin_url
    $(window).trigger('setup.game.change')

  handleSeedClick: (event) ->
    $(window).trigger('modal.open', `<SeedModal />`)

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/api/things/random.json", {}, (thing) ->
      self.handleSeedSelect({}, thing);
    )
    event?.preventDefault()

  render: () ->
    `<div className={this.className}>
      <h3 className="games-setup__seed-title">Seed Node</h3>
      <img className="games-setup__seed-image"
        key={this.state.image_url}
        src={this.state.image_url}
        width="120" height="120" 
        onClick={this.handleSeedClick} />
      <h3 className="games-setup__seed-randomise">
        <a href="#" onClick={this.handleRandomSeed}><i className="fa fa-random"></i> <span>Randomise</span></a>
      </h3>
      <Searcher prefix="setup.seed.searcher" />
      <input type="hidden" name={this.props.seed.form_name} value={this.state.id} />
    </div>`

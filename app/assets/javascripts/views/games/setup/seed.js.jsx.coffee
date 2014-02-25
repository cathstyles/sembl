###* @jsx React.DOM ###

@Sembl.Games.Setup.Seed = React.createClass
  className: "games-setup__seed"

  getInitialState: () ->
    id: this.props.seed.id
    title: this.props.seed.title || ""
    image_url: this.props.seed.image_url || "http://placehold.it/120x120"

  componentWillMount: () ->
    self = this
    $.getJSON("/things/"+ this.state.id+".json", {}, (data) ->
      self.handleNewSeed(data);
      console.log data
    )

  handleNewSeed: (seed) ->
    this.setState
      id: seed.id
      title: seed.title
      image_url: seed.image_admin_url

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/things/random.json", {}, (data) ->
      self.handleNewSeed(data);
    )
    event.preventDefault()

  handleChooseBoardToggle: () ->
    component = this.refs.toggle
    if component.state.toggle
      component.handleToggleOff()
    else
      component.handleToggleOn()

  render: () ->
    `<div className={this.className}>
      <h3 className="games-setup__seed-title">Seed Node</h3>
      <img key={this.state.image_url} src={this.state.image_url} className="games-setup__seed-image" width="120" height="120" />
      <h3 className="games-setup__seed-randomise"><a href="#" onClick={this.handleRandomSeed}><i className="fa fa-random"></i> <span>Randomise</span></a></h3>
      <input type="hidden" name={this.props.seed.form_name} value={this.state.seed_id} />
    </div>`

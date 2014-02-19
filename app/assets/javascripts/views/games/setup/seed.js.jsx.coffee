###* @jsx React.DOM ###

@Sembl.Games.Setup.Seed = React.createClass
  className: "games-setup__seed"

  getInitialState: () ->
    id: this.props.seed.id
    title: this.props.seed.title || ""
    image_url: this.props.seed.image_url || "http://example.com"

  componentWillMount: () ->
    self = this
    $.getJSON("/things/"+this.state.id+".json", {}, (data) ->
      self.handleNewSeed({id: data.id, title: data.title, image_url: data.image_browse_url});
    )

  handleNewSeed: (seed) ->
    this.setState
      id: seed.id
      title: seed.title
      image_url: seed.image_url


  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/things/random.json", {}, (data) ->
      self.handleNewSeed({id: data.id, title: data.title, image_url: data.image_browse_url});
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
      <div>SEED NODE</div>
      <div>{this.state.title}</div>
      <img src={this.state.image_url} />
      <div><a href="#" onClick={this.handleRandomSeed}>RANDOMIZE</a></div>
      <input type="hidden" name={this.props.seed.form_name} value={this.state.seed_id} />
    </div>`

#= require views/games/setup/steps/step_seed_thing_modal
#= require views/components/searcher
#= require views/games/gallery
#= require underscore

###* @jsx React.DOM ###


Checkbox = React.createClass
  handleChange: (event) ->
    @props.handleChange(@props.name, event.target.checked)

  render: () ->
    checked = if @props.checked? then @props.checked else null
    className = "setup__steps__seed__#{@props.name}"
    `<div className={className}>
      <label>
        {this.props.label}
        <input type="checkbox" checked={checked} onChange={this.handleChange} />
      </label>
    </div>`

{StepSeedThingModal} = Sembl.Games.Setup
{TransloaditUploadComponent, Searcher} = Sembl.Components
{Gallery} = Sembl.Games

@Sembl.Games.Setup.StepSeed = React.createClass
  galleryPrefix: "setup.steps.seed.gallery"

  getInitialState: ->
    auth_token: $('meta[name="csrf-token"]').attr "content"
    upload_complete: false
    upload_submitting: false
    upload_url: null
    upload_title: null
    upload_description: null

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
    $(window).trigger('slideViewer.setChild',
      full: true
      child: `<div>
        <div className="slide-viewer__controls">
          <Checkbox name='suggested_seed' label="Suggested seeds" handleChange={this.handleCheckboxChange} />
          <div className="setup__steps__seed__search">
            <label>
              Search for a seed:
              <input name='text' onChange={this.handleInputChange}/>
            </label>
          </div>
        </div>
        <Gallery searcherPrefix={this.props.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>`
    )

  handleCheckboxChange: (name, value) ->
    filter = _.extend({}, @props.filter)
    filter[name] = 1 if value == true
    $(window).trigger("#{this.props.searcherPrefix}.setFilter", filter)

  handleInputChange: (event) ->
    name = event.target.name
    value = event.target.value
    filter = _.extend({}, @props.filter)
    filter[name] = value
    $.doTimeout('debounce.setup.steps.seed.search.text.change', 200,
      =>
        @setSlideViewer()
        $(window).trigger("#{this.props.searcherPrefix}.setFilter", filter)
    )

  handleViewImageClick: (event) ->
    event.preventDefault()
    $(window).trigger('modal.open', `<StepSeedThingModal selectEvent='setup.steps.seed.select' thing={this.props.seed} />`)

  handleGalleryClick: (event, thing) ->
    $(window).trigger('modal.open', `<StepSeedThingModal selectEvent='setup.steps.seed.select' thing={thing} />`)

  handleSeedSelect: (event, thing) ->
    $(window).trigger('slideViewer.hide')
    $(window).trigger('setup.steps.change', {seed: thing})

  handleSeedClick: (event) ->
    event.preventDefault()
    $(window).trigger('slideViewer.show')

  handleRandomSeed: (event) ->
    self = this
    $.getJSON("/api/things/random.json", {}, (thing) ->
      self.handleSeedSelect({}, thing);
    )
    event?.preventDefault()

  isValid: -> @props.seed? && @props.seed.id?

  # Uploading
  finishedUpload: (results) ->
    @setState
      upload_url: results[':original'][0].url


  onUploadSubmit: (e) ->
    e.preventDefault()
    @setState
      upload_submitting: true
    data =
      thing:
        remote_image_url: @state.upload_url
        title: @state.upload_title
        description: @state.upload_description
      game_id: Sembl.game.id
      authenticity_token: @state.auth_token
    @postThing(data)

  postThing: (data) ->
    url = '/api/things.json'
    success = (response) =>
      $(window).trigger('setup.steps.change', {seed: response})
      @setState
        upload_complete: true
        upload_url: null
        upload_title: null
        upload_description: null
    error = (response) =>
      console.error 'error!', response
      try
        responseObj = JSON.parse(response.responseText)
        if response.status == 422
          msgs = (value for key, value of responseObj.errors)
          $(window).trigger('flash.error', msgs.join(", "))
        else
          $(window).trigger('flash.error', "Error: #{responseObj.errors}")
      catch e
        console.error e
    $.ajax
      url: url
      data: data
      type: 'POST'
      dataType: 'json'
      success: success
      error: error

  newUpload: (e) ->
    e.preventDefault()
    @setState
      upload_complete: false
      upload_submitting: false
      upload_url: null
      upload_title: null
      upload_description: null


  handleUploadChange: (attr, e) ->
    state = _.extend {}, @state
    state[attr] = e.target.value
    @setState state

  formatUploader: ->
    file = if @state.upload_url
      `<img className="setup__steps__seed-upload__image" src={this.state.upload_url}/>`
    else
      `<TransloaditUploadComponent finishedUpload={this.finishedUpload} />`

    buttonClass = if @uploadValid()
      "setup__steps__seed-upload__button"
    else
      "setup__steps__seed-upload__button button--disabled"

    `<div className="setup__steps__seed-upload">
      <p>You can also upload your own custom one below:</p>
      {file}
      <div className="setup__steps__seed-upload__title">
        <h3>Title</h3>
        <input type="text" onChange={this.handleUploadChange.bind(this, "upload_title")}/>
      </div>
      <div className="setup__steps__seed-upload__description">
        <h3>Description</h3>
        <textarea onChange={this.handleUploadChange.bind(this, "upload_description")}/>
      </div>
      <button className={buttonClass} type="submit" disabled={!this.uploadValid()} onClick={this.onUploadSubmit}>Add this image</button>
    </div>`

  uploadValid: ->
    (@state.upload_url? && @state.upload_title?)

  render: ->
    seed = @props.seed
    image_url = seed?.image_admin_url
    seedPlacementClassName = if seed?.id
      "game__placement state-filled"
    else
      "game__placement state-available"

    upload = if @state.upload_complete
      `<p>Done! <a href="#" onClick={this.newUpload}>Upload another?</a></p>`
    else if @state.upload_submitting
      `<p>Saving your image ...</p>`
    else
      @formatUploader()

    `<div className="setup__steps__seed">
      <div className="setup__steps__title">Choose a seed:</div>
      <div className="setup__steps__inner">
        <a className={seedPlacementClassName} onClick={this.handleViewImageClick}>
          <img className="game__placement__image" key={image_url} src={image_url} />
        </a>
        <div className="setup__steps__seed-options">
          <a href="#seed" onClick={this.handleSeedClick}>
            <i className="fa fa-th"/>&nbsp;<em>Select</em>
          </a>
          &nbsp;or&nbsp;
          <a href="#random" onClick={this.handleRandomSeed}><i className="fa fa-random"/>&nbsp;<em>Random</em></a>
        </div>
        <div className="setup__steps__seed-custom">
          {upload}
        </div>
      </div>
    </div>`

#= require views/components/transloadit_upload
#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{classSet} = React.addons
{Gallery} = @Sembl.Games
{TransloaditUploadComponent, ThingModal} = @Sembl.Components

@Sembl.Games.Setup.StepUpload = React.createClass
  galleryPrefix: "setup.steps.upload.gallery"
  searcherPrefix: "setup.steps.upload.searcher" # we don't actually search

  getInitialState: ->
    title: null
    description: null
    attribution: null
    access_via: null
    copyright: null
    dates: null
    keywords: null
    places: null
    node_type: null
    item_url: null
    remoteImageUrl: null

  componentDidMount:->
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)
    @getThings()

  componentWillUnmount: ->
    $(window).off("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)

  handleChange: (event) ->
    state = {}
    state[event.target.name] = event.target.value
    @setState state

  bubbleChange: (state) ->
    $(window).trigger('setup.steps.change', {description: state.description})

  handleGalleryThingClick: (event, thing) ->
    if @props.galleryClickEvent?
      $(window).trigger(@props.galleryClickEvent, thing)
    else
      $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  handleSubmit: (event) ->
    event.preventDefault()
    if @_uploadValid()
      data =
        thing:
          title: @state.title
          description: @state.description
          attribution: @state.attribution
          access_via: @state.access_via
          copyright: @state.copyright
          dates: @state.dates
          keywords: @state.keywords
          places: @state.places
          node_type: @state.node_type
          item_url: @state.item_url
          remote_image_url: @state.remoteImageUrl
        game_id: @props.game.id
        authenticity_token: @props.game.get('auth_token')
      @postThing(data)

  finishedUpload: (results) ->
    remoteImageUrl = results[':original'][0].url
    @setState {remoteImageUrl}

  postThing: (data) ->
    url = '/api/things.json'
    success = (data) =>
      @getThings()
      @setState
        title: ""
        description: ""
        attribution: ""
        access_via: ""
        copyright: ""
        dates: null
        keywords: null
        places: null
        node_type: null
        item_url: null
        remoteImageUrl: null
        submitting: false
    error = (response) =>
      console.error 'error!', response
      @setState submitting: false
      try
        responseObj = JSON.parse(response.responseText)
        if response.status == 422
          msgs = (value for key, value of responseObj.errors)
          $(window).trigger('flash.error', msgs.join(", "))
        else
          $(window).trigger('flash.error', "Error: #{responseObj.errors}")
      catch e
        console.error e

    @setState submitting: true
    $.ajax(
      url: url
      data: data
      type: 'POST'
      dataType: 'json'
      success: success
      error: error
    )

  getThings: (data) ->
    url = "/api/things.json?game_id=#{@props.game.id}"
    $.ajax(
      url: url
      data: data
      type: 'GET'
      dataType: 'json'
      success: (things) =>
        results = for i,thing of things
          index: parseInt(i)
          thing: thing
        $(window).trigger("#{this.searcherPrefix}.updated", {
          results:
            hits: results
            total: results.length
        })
        @setState totalUploads: results.length
    )

  getInitialState: ->
    totalUploads: 0
    submitting: false

  render: ->
    game = @props.game

    hasImage = @state.remoteImageUrl?

    uploadFormClassName = classSet
      "setup__steps__upload-fields": true
      "setup__steps__upload-fields--disabled": !@_uploadValid()

    # TODO: add fields for setting source and other metadata?
    transloadit = `<TransloaditUploadComponent finishedUpload={this.finishedUpload} />`
    image = `<img className="setup__steps__upload__uploader__image" src={this.state.remoteImageUrl} alt={this.state.title} />`
    uploadForm = if !@state.submitting
        `<div className={uploadFormClassName}>
          <div className="setup__steps__upload__uploader">
            {hasImage ? image : transloadit}
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              Title*:
            </label>
            <input name="title" value={this.state.title} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
            <span className="setup__hint">Give it a short title</span>
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              Description*:
            </label>
            <textarea name="description" value={this.state.description} onChange={this.handleChange} className="setup__steps__upload-step__input" rows="5"></textarea>
            <span className="setup__hint">Tell us what it depicts, and whatever else we need to know in order to understand it.</span>
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              Credit:
            </label>
            <input name="attribution" value={this.state.attribution} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
            <span className="setup__hint">Who created this? If appropriate, name more than one person. If the copyright holder requires a special form of attribution, put that in here.</span>
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              Access via:
            </label>
            <input name="access_via" value={this.state.access_via} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
            <span className="setup__hint">If you got this image from the web, name the site.</span>
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              Copyright:
            </label>
            <input name="copyright" value={this.state.copyright} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
            <span className="setup__hint">Identify your right to share the image. E.g., say 'public domain', 'by permission', 'CC-BY-SA'.</span>
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Dates:</label>
            <input name="dates" value={this.state.dates} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Places:</label>
            <input name="places" value={this.state.places} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Node type:</label>
            <input name="node_type" value={this.state.node_type} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Keywords:</label>
            <input name="keywords" value={this.state.keywords} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">
              URL:
            </label>
            <input name="item_url" value={this.state.item_url} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
            <span className="setup__hint">Paste in the web address – preferably a persistent one.</span>
          </div>
          <div className="setup__steps__upload-step">
            <button onClick={this.handleSubmit} className="setup__steps__upload-step__submit">Add this image</button>
          </div>
        </div>`
      else
        `<div>
          <p>Processing&hellip;</p>
          <progress className="uploader-progress-bar" key="process"></progress>
        </div>`


    `<div className="setup__steps__upload">
      <div className="setup__steps__title">Upload your own images</div>
      <div className="setup__steps__inner">
        <div className="setup__steps__upload-description copy">
          <p>Please only upload good-quality images that you are entitled to share. 1500px is great – JPG, GIF or PNG. The more we know about an image, the more useful and interesting it becomes. Please tell us as much as you can. That said, only Title and Description are mandatory.</p>
        </div>
        {uploadForm}
      </div>
      <div className="setup__steps__title">Custom images already available</div>
      <div className="setup__steps__uploads__gallery">
        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`

  _uploadValid: ->
    (@state.remoteImageUrl? && @state.title? && @state.description?)

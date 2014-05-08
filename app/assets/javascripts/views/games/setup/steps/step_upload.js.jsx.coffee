#= require views/components/transloadit_upload
#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{Gallery} = @Sembl.Games
{TransloaditUploadComponent, ThingModal} = @Sembl.Components

@Sembl.Games.Setup.StepUpload = React.createClass
  galleryPrefix: "setup.steps.upload.gallery"
  searcherPrefix: "setup.steps.upload.searcher" # we don't actually search

  getInitialState: ->
    title: null
    description: null
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
    data = 
      thing:
        title: @state.title
        description: @state.description
        remote_image_url: @state.remoteImageUrl
      game_id: @props.game.id
      authenticity_token: @props.game.get('auth_token')
    @postThing(data)

  finishedUpload: (results) ->
    console.log 'finished transloadit upload', results
    remoteImageUrl = results[':original'][0].url
    @setState {remoteImageUrl}

  postThing: (data) ->
    url = '/api/things.json'
    success = (data) =>
      console.log 'success!', data
      @getThings()
      @setState 
        title: ""
        description: ""
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
          index: Number.parseInt(i)
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

    # TODO: add fields for setting source and other metadata?
    hasImage = !!@state.remoteImageUrl
    hasTitle = !!@state.title
    submitDisabled = hasImage && hasTitle # TODO disable the button

    transloadit = `<TransloaditUploadComponent finishedUpload={this.finishedUpload} />`
    image = `<img className="setup__steps__upload__uploader__image" src={this.state.remoteImageUrl} alt={this.state.title} />`
    uploadForm = if !@state.submitting
        `<div className="setup__steps__upload-fields">
          <div className="setup__steps__upload__uploader">
            {hasImage ? image : transloadit}
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Title:</label>
            <input name="title" value={this.state.title} onChange={this.handleChange} className="setup__steps__upload-step__input" type="text" />
          </div>
          <div className="setup__steps__upload-step">
            <label className="setup__steps__upload-step__label">Description:</label>
            <textarea name="description" value={this.state.description} onChange={this.handleChange} className="setup__steps__upload-step__input" rows="5"></textarea>
          </div>
          <div className="setup__steps__upload-step">
            <input type="submit" onClick={this.handleSubmit} className="setup__steps__upload-step__submit" value="Add this image" />
          </div>
        </div>`
      else 
        `<div>
          <p>Processing&hellip;</p>
          <progress className="uploader-progress-bar" key="process"></progress>
        </div>`


    `<div className="setup__steps__upload">
      <div className="setup__steps__title">Upload your own images for use in the game:</div>
      <div className="setup__steps__inner">
        {uploadForm}
      </div>
      <div className="setup__steps__uploads__available">There are {this.state.totalUploads} custom images for this game</div>
      <div className="setup__steps__uploads__gallery">
        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`
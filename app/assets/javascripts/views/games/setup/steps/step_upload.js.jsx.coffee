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
      @setState title: "", description: "", remoteImageUrl: null
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
        $(window).trigger("#{this.searcherPrefix}.updated", {results: results})
    )

  render: ->
    game = @props.game

    # TODO: add fields for setting source and other metadata?
    hasImage = !!@state.remoteImageUrl
    hasTitle = !!@state.title

    transloadit = `<TransloaditUploadComponent finishedUpload={this.finishedUpload} />`
    image = `<img src={this.state.remoteImageUrl} alt={this.state.title} />`

    `<div className="setup__steps__upload">
      <div className="setup__steps__title">Upload some images for this game</div>
      <div className="setup__steps__inner">
        <div class="setup__steps__upload__uploader">
          {hasImage ? image : transloadit}
        </div>
        <div>
          <label>Title: <input name="title" value={this.state.title} onChange={this.handleChange} /></label>
        </div>
        <div>
          <label>Description: <input name="description" value={this.state.description} onChange={this.handleChange} /></label>
        </div>
        <input class="button--disabled" type="submit" onClick={this.handleSubmit} />

        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`

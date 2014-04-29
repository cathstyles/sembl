#= require views/components/transloadit_upload
#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{Gallery} = @Sembl.Games
{TransloaditUploadComponent, ThingModal} = @Sembl.Components

@Sembl.Games.Setup.StepUpload = React.createClass
  galleryPrefix: "setup.steps.upload.gallery"
  searcherPrefix: "setup.steps.upload.searcher" # we don't really do any searching

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
    `<div className="setup__steps__upload">
      <div className="setup__steps__title">Upload some images for this game</div>
      <div className="setup__steps__inner">
        <TransloaditUploadComponent finishedUpload={this.finishedUpload} />
        <img src={this.state.remoteImageUrl} />
        <form onSubmit={this.handleSubmit}>
          <input name="title" value={this.state.title} onChange={this.handleChange} />
          <input name="description" value={this.state.description} onChange={this.handleChange} />
          <input type="submit" />
        </form>
        <Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`

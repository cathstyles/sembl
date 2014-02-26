#= require image_area_select

###* @jsx React.DOM ###
NewContribution = React.createClass
  getInitialState: ->
    step: 0

  componentWillMount: ->
    new TransloaditBoredInstance(@foundBoredInstance)
    new TransloaditSignature('thingsStoreOriginal', @signatureLoaded)

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkLoadComplete()

  signatureLoaded: (template) ->
    @uploadTemplate = template
    @checkLoadComplete()

  checkLoadComplete: ->
    @setState step: 1 if @transloaditInstance and @uploadTemplate

  setCropSrc: (url) ->
    @cropUrl = url
    @setState step: 2

  finishedCrop: ->
    @setState step: 3

  render: ->
    currentComponent = switch @state.step
      when 0
        `<div>Loading…</div>`

      when 1
        `<UploadComponent
          transloaditTemplate={this.uploadTemplate}
          transloaditInstance={this.transloaditInstance}
          setCropSrc={this.setCropSrc}
        />`

      when 2
        `<CropComponent
          cropUrl={this.cropUrl}
          finishedCrop={this.finishedCrop}
        />`

      when 3
        `<div>Processing…</div>`

      when 4
        `<ThingComponent />`

    `<div className="new-contribution">
      {currentComponent}
    </div>`

UploadComponent = React.createClass
  getInitialState: ->
    loading: false

  componentWillMount: ->
    @assemblyId  = genUUID()
    @assemblyUrl = "#{PROTOCOL}://#{@props.transloaditInstance}/assemblies/#{@assemblyId}"
    @postUrl     = "#{@assemblyUrl}?redirect=false"

  handleSubmit: ->
    @setState loading: true
    @uploadPoll()

  uploadPoll: ->
    setTimeout @queryAssembly, 1000

  queryAssembly: ->
    $.ajax
      url: @assemblyUrl
      dataType: 'json'
      context: this
      success: (data) ->
        if data.ok is 'ASSEMBLY_COMPLETED'
          @props.setCropSrc data.results[':original'][0].url
        else
          @uploadPoll()

  render: ->
    hidden = display: 'none'

    loadingStyle = if @state.loading then {} else hidden
    formStyle    = if @state.loading then hidden else {}

    `<div>
      <iframe name="transloadit" style={hidden} />
      <form
        encType="multipart/form-data"
        onSubmit={this.handleSubmit}
        action={this.postUrl}
        target="transloadit"
        method="POST"
        style={formStyle}
      >
        <input name="params" type="hidden" value={JSON.stringify(this.props.transloaditTemplate.params)} />
        <input name="signature" type="hidden" value={this.props.transloaditTemplate.signature} />
        <input name="thing" type="file" />
        <input type="submit" value="Upload" />
      </form>
      <span style={loadingStyle}>Uploading…</span>
    </div>`

CropComponent = React.createClass
  componentDidMount: ->
    $('img').imgAreaSelect
      handles: true
      show: true
      onSelectEnd: (img, coordinates) =>
        @cropCoordinates = coordinates

  componentWillUnmount: ->
    $('img').imgAreaSelect remove: true

  handleSubmit: ->
    if @cropCoordinates and not @loading
      @loading = true
      new TransloaditBoredInstance(@foundBoredInstance)
      new TransloaditSignature('thingsCrop', @signatureLoaded)

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkLoadComplete()

  signatureLoaded: (template) ->
    @cropTemplate = template
    @checkLoadComplete()

  checkLoadComplete: ->
    @cropImage() if @cropTemplate and @transloaditInstance

  cropImage: ->
    @assemblyUrl = "#{PROTOCOL}://#{@transloaditInstance}/assemblies"

    $.ajax
      url: "#{@assemblyUrl}?redirect=false"
      dataType: 'json'
      contentType: 'application/json; charset=utf-8'
      type: 'POST'
      context: this
      data:
        JSON.stringify
          params: $.extend @cropTemplate.params,
            steps:
              import: url: @props.cropUrl
              crop: crop: @coordinates
          signature: @cropTemplate.signature
      success: (data) ->
        @props.finishedCrop()

  render: ->
    `<div>
      <img src={this.props.cropUrl} />
      <button onClick={this.handleSubmit}>Crop</button>
    </div>`


window.contributionsView = (el) ->
  React.renderComponent NewContribution(), el

class TransloaditBoredInstance
  constructor: (@successCallback) ->
    @api = "#{PROTOCOL}://api2.transloadit.com/"
    @getBoredInstance()

  getBoredInstance: ->
    $.ajax
      url: "#{@api}instances/bored?callback=?"
      dataType: 'jsonp'
      context: this
      success: (data) ->
        if data.error
          @getBoredInstanceAgain()
        else
          @successCallback data.api2_host
      error: ->
        @getBoredInstanceAgain()

  getBoredInstanceAgain: ->
    setTimeout @getBoredInstance, 1000 # TODO debounce

class TransloaditSignature
  constructor: (@templateName, @successCallback) ->
    @getTransloaditSignature()

  getTransloaditSignature: ->
    $.ajax
      url: '/transloadit_signatures/' + @templateName.camelToUnderscore()
      dataType: 'json'
      context: this
      success: (data) ->
        @successCallback data

genUUID = ->
  time = new Date().getTime()

  uuid = 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace /[xy]/g, (char) ->
    random = (time + Math.random() * 16) % 16 | 0
    time = Math.floor(time / 16)
    (if char is 'x' then random else (random & 0x7 | 0x8)).toString(16)

  uuid

String.prototype.camelToUnderscore = ->
  @replace /([a-z][A-Z])/g, (g) -> g[0] + '_' + g[1].toLowerCase()

PROTOCOL = if document.location.protocol is 'https:' then 'https' else 'http'

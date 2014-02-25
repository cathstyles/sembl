#= require image_area_select

###* @jsx React.DOM ###
NewContribution = React.createClass
  getInitialState: ->
    step: 0

  componentWillMount: ->
    @transloaditTemplates = {}
    @getTransloaditSignature 'thingsStoreOriginal'

    new TransloaditBoredInstance(@foundBoredInstance)

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkLoadComplete()

  getTransloaditSignature: (templateName) ->
    $.ajax
      url: '/transloadit_signatures/' + templateName.camelToUnderscore()
      dataType: 'json'
      context: this
      success: (data) ->
        @transloaditTemplates[templateName] = data
        @checkLoadComplete()

  checkLoadComplete: ->
    if @transloaditInstance
      switch @state.step
        when 0
          @setState step: 1 if @transloaditTemplates['thingsStoreOriginal']
        when 3
          @cropImage() if @transloaditTemplates['thingsCrop']

  setCropSrc: (url) ->
    @cropUrl = url
    @setState step: 2

  setCropCoordinates: (coordinates) ->
    @coordinates = coordinates
    @setState step: 3
    @transloaditInstance = null
    new TransloaditBoredInstance(@foundBoredInstance)
    @getTransloaditSignature 'thingsCrop'

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
          params: $.extend @transloaditTemplates['thingsCrop'].params,
            steps:
              import: url: @cropUrl
              crop: crop: @coordinates
          signature: @transloaditTemplates['thingsCrop'].signature
      success: (data) ->
        console.log data

  render: ->
    currentComponent = switch @state.step
      when 0
        `<div>Loading…</div>`

      when 1
        `<UploadComponent
          transloaditTemplate={this.transloaditTemplates.thingsStoreOriginal}
          transloaditInstance={this.transloaditInstance}
          setCropSrc={this.setCropSrc}
        />`

      when 2
        `<CropComponent
          cropUrl={this.cropUrl}
          setCropCoordinates={this.setCropCoordinates}
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
    @props.setCropCoordinates @cropCoordinates

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

genUUID = ->
  time = new Date().getTime()

  uuid = 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace /[xy]/g, (char) ->
    random = (time + Math.random() * 16) % 16 | 0
    time = Math.floor(time / 16)
    (if char is 'x' then random else (random & 0x7 | 0x8)).toString(16)

  uuid

String.prototype.camelToUnderscore = ->
  @replace /([a-z][A-Z])/g, (g) -> g[0] + '_' + g[1].toLowerCase()

PROTOCOL = 'http' # FIXME HTTPS if Sembl has SSL

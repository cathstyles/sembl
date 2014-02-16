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

  checkLoadComplete: ->
    if @state.step is 0 and @transloaditTemplates and @transloaditInstance
      @setState step: 1

  getTransloaditSignature: (templateName) ->
    $.ajax
      url: '/transloadit_signatures/' + templateName.camelToUnderscore()
      dataType: 'json'
      context: this
      success: (data) ->
        @transloaditTemplates[templateName] = data
        @checkLoadComplete()

  setCropSrc: (url) ->
    @cropUrl = url
    @setState step: 2

  render: ->
    currentComponent = switch @state.step
      when 0
        `<div>loading…</div>`

      when 1
        `<UploadComponent
          transloaditTemplate={this.transloaditTemplates.thingsStoreOriginal}
          transloaditInstance={this.transloaditInstance}
          setCropSrc={this.setCropSrc}
        />`

      when 2
        `<CropComponent
          cropUrl={this.cropUrl}
        />`

      when 3
        `<ThingComponent />`

    `<div className="new-contribution">
      {currentComponent}
    </div>`

UploadComponent = React.createClass
  componentWillMount: ->
    @assemblyId  = genUUID()
    @assemblyUrl = "#{PROTOCOL}://#{@props.transloaditInstance}/assemblies/#{@assemblyId}"
    @postUrl     = "#{@assemblyUrl}?redirect=false"

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

    `<div>
      <iframe name="transloadit" style={hidden} />
      <form
        encType="multipart/form-data"
        onSubmit={this.uploadPoll}
        action={this.postUrl}
        target="transloadit"
        method="POST"
      >
        <input name="params" type="hidden" value={JSON.stringify(this.props.transloaditTemplate.params)} />
        <input name="signature" type="hidden" value={this.props.transloaditTemplate.signature} />
        <input name="thing" type="file" />
        <input type="submit" value="Upload" />
      </form>
    </div>`

CropComponent = React.createClass
  render: ->
    `<img src={this.props.cropUrl} />`


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

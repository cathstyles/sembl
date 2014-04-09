#= require views/utils/utils 
#= require views/utils/transloadit_handlers 

###* @jsx React.DOM ###
{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.Components.TransloaditUploadComponent = React.createClass
  getInitialState: ->
    state: 'initialising'

  componentWillMount: ->
    new TransloaditBoredInstance(@foundBoredInstance)
    new TransloaditSignature('thingsStoreOriginal', @signatureLoaded)

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkInitComplete()

  signatureLoaded: (template) ->
    @uploadTemplate = template
    @checkInitComplete()

  checkInitComplete: -> 
    if @transloaditInstance and @uploadTemplate
      @assemblyId  = window.Sembl.Utils.genUUID()
      @assemblyUrl = "#{window.Sembl.Utils.PROTOCOL}://#{@transloaditInstance}/assemblies/#{@assemblyId}"
      @postUrl     = "#{@assemblyUrl}?redirect=false"
      @setState state: 'ready'

  handleSubmit: ->
    @setState state: 'uploading'
    @uploadPoll()

  uploadPoll: ->
    setTimeout @queryAssembly, 1000

  queryAssembly: ->
    $.ajax
      context: this
      dataType: 'json'
      url: @assemblyUrl
      success: (data) ->
        if data.ok is 'ASSEMBLY_COMPLETED'
          @props.finishedUpload data.results[':original'][0].url
        else
          @uploadPoll()

  render: ->
    hidden = display: 'none'
    componentForState = switch @state.state
      when 'initialising'
        `<span>Loading…</span>`

      when 'uploading'
        `<span>Uploading</span>`

      when 'ready'
        `<form
          encType="multipart/form-data"
          onSubmit={this.handleSubmit}
          action={this.postUrl}
          target="transloadit"
          method="POST"
        >
          <input name="params" type="hidden" value={JSON.stringify(this.uploadTemplate.params)} />
          <input name="signature" type="hidden" value={this.uploadTemplate.signature} />
          <input name="thing" type="file" />
          <input type="submit" value="Upload" />
        </form>` 

    `<div>
      <iframe name="transloadit" style={hidden} />
      {componentForState}
    </div>`
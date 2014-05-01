#= require views/utils/utils 
#= require views/utils/transloadit_handlers 

###* @jsx React.DOM ###
{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.Components.TransloaditUploadComponent = React.createClass
  getInitialState: ->
    state: 'initialising'
    progress: 0.02

  componentWillMount: ->
    new TransloaditBoredInstance(@foundBoredInstance)
    new TransloaditSignature('thingsStoreOriginal', @signatureLoaded)

  componentDidMount: -> 
    @submitOnFileSelected()

  componentDidUpdate: ->
    @submitOnFileSelected()

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

  submitOnFileSelected: -> 
    $el = $(@getDOMNode())
    $el.find('input:file').on('change', => 
      $el.find('form').submit()
      @handleSubmit()
    )

  handleSubmit: ->
    @setState state: 'uploading'
    @uploadPoll()

  uploadPoll: ->
    setTimeout @queryAssembly, 1000

  updateProgress: (data) ->
    console.log data
    pctProgress = 0
    percent = data.bytes_received / data.bytes_expected
    percent = 0.02 if percent < 0.02
    @state.state = 'processing' if percent == 1
    @state.progress = percent
    
    @setState @state

  queryAssembly: ->
    $.ajax
      context: this
      dataType: 'json'
      url: @assemblyUrl
      success: (data) ->
        if data.ok is 'ASSEMBLY_COMPLETED'
          console.log 'assembly completed'
          @props.finishedUpload data.results
        else
          @updateProgress(data)
          @uploadPoll()
      error: (response) ->
        console.error 'error!', response

  render: ->
    hidden = display: 'none'
    componentForState = switch @state.state
      when 'initialising'
        `<span>Loading…</span>`

      when 'uploading'
        progressWidth = width: @state.progress + "%"
        `<div>Uploading…
          <progress className="uploader-progress-bar" key="file" value={this.state.progress}></progress>
        </div>`

      when 'processing'
        `<div>
          <p>Processing…</p>
          <progress className="uploader-progress-bar" key="process"></progress>
        </div>`

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
        </form>` 

    `<div className="upload">
      <iframe name="transloadit" style={hidden} />
      {componentForState}
    </div>`
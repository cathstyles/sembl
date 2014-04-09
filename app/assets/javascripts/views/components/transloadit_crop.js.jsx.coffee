#= require image_area_select
#= require views/utils/transloadit_handlers
#= require views/utils/utils

###* @jsx React.DOM ###

{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.Components.TransloaditCropComponent = React.createClass
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

      new TransloaditSignature('thingsCrop', @signatureLoaded,
        params: steps:
          import: url: @props.cropUrl
          crop: crop: @cropCoordinates
      )

  foundBoredInstance: (apiHost) ->
    @transloaditInstance = apiHost
    @checkInitComplete()

  signatureLoaded: (template) ->
    @cropTemplate = template
    @checkInitComplete()

  checkInitComplete: ->
    @cropImage() if @cropTemplate and @transloaditInstance

  cropImage: ->
    @assemblyId  = window.Sembl.Utils.genUUID()
    @assemblyUrl = "#{window.Sembl.Utils.PROTOCOL}://#{@transloaditInstance}/assemblies/#{@assemblyId}"

    boundary = '----TransloaditBoundaryc7IhCATk2lNuFcR'

    formPost = """
      --#{boundary}
      Content-Disposition: form-data; name="params"

      #{JSON.stringify(@cropTemplate.params)}
      --#{boundary}
      Content-Disposition: form-data; name="signature"

      #{@cropTemplate.signature}
      --#{boundary}--
    """.replace /\n/g, "\r\n"

    $.ajax
      cache: false
      contentType: "multipart/form-data; boundary=#{boundary}"
      context: this
      data: formPost
      dataType: 'json'
      processData: false
      type: 'POST'
      url: @assemblyUrl
      success: (data) ->
        @assemblyPoll()

  assemblyPoll: ->
    setTimeout @queryAssembly, 1000

  queryAssembly: ->
    $.ajax
      context: this
      dataType: 'json'
      url: @assemblyUrl
      success: (data) ->
        if data.ok is 'ASSEMBLY_COMPLETED'
          @props.finishedCrop data.results.crop[0].url
        else
          @assemblyPoll()

  render: ->
    `<div>
      <img src={this.props.cropUrl} />
      <button onClick={this.handleSubmit}>Crop</button>
    </div>`
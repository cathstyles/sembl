#= require views/utils/utils 

###* @jsx React.DOM ###

@Sembl.Components.TransloaditUploadComponent = React.createClass
  getInitialState: ->
    loading: false

  componentWillMount: ->
    @assemblyId  = window.Sembl.Utils.genUUID()
    @assemblyUrl = "#{window.Sembl.Utils.PROTOCOL}://#{@props.transloaditInstance}/assemblies/#{@assemblyId}"
    @postUrl     = "#{@assemblyUrl}?redirect=false"

  handleSubmit: ->
    @setState loading: true
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
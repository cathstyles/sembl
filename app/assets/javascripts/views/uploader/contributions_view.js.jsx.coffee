#= require views/components/transloadit_upload
#= require views/components/transloadit_crop
#= require views/utils/transloadit_handlers

###* @jsx React.DOM ###
{TransloaditUploadComponent, TransloaditCropComponent} = @Sembl.Components
{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.NewContribution = React.createClass
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

  finishedCrop: (url) ->
    @croppedUrl = url
    @setState step: 3

  render: ->
    currentComponent = switch @state.step
      when 0
        `<div>Loading…</div>`

      when 1
        `<TransloaditUploadComponent
          transloaditTemplate={this.uploadTemplate}
          transloaditInstance={this.transloaditInstance}
          setCropSrc={this.setCropSrc}
        />`

      when 2
        `<TransloaditCropComponent
          cropUrl={this.cropUrl}
          finishedCrop={this.finishedCrop}
        />`

      when 3
        `<ThingComponent
          croppedUrl={this.croppedUrl}
        />`

    `<div className="new-contribution">
      {currentComponent}
    </div>`





ThingComponent = React.createClass
  render: ->
    `<img src={this.props.croppedUrl} />`

window.contributionsView = (el) ->
  React.renderComponent @Sembl.NewContribution(), el



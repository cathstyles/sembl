#= require views/components/transloadit_upload
#= require views/components/transloadit_crop

###* @jsx React.DOM ###
{TransloaditUploadComponent, TransloaditCropComponent} = @Sembl.Components
{TransloaditBoredInstance, TransloaditSignature} = @Sembl.Handlers

@Sembl.ThingComponent = React.createClass
  render: ->
    `<img src={this.props.croppedUrl} />`


@Sembl.NewContribution = React.createClass
  getInitialState: ->
    step: 1

  setCropSrc: (results) ->
    @cropUrl = results[':original'][0].url
    @setState step: 2

  finishedCrop: (results) ->
    @croppedUrl = results.crop[0].url
    @setState step: 3

  render: ->
    ThingComponent = @Sembl.ThingComponent
    currentComponent = switch @state.step
      when 1
        `<TransloaditUploadComponent
          finishedUpload={this.setCropSrc}
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

window.contributionsView = (el) ->
  React.renderComponent @Sembl.NewContribution(), el



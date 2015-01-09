#= require jquery
#= require views/components/transloadit_upload

###* @jsx React.DOM ###
{TransloaditUploadComponent} = @Sembl.Components

@Sembl.NewAvatar = React.createClass
  getInitialState: ->
    if !!this.props.avatarUrl
      step: 2
    else
      step: 1

  componentDidMount: ->
    @$form = $(@props.avatarFormSelector)

  finishedUpload: (results) ->
    @avatarRemoteUrl = results[':original'][0].url
    $("#profile_remote_avatar_url").val(@avatarRemoteUrl)
    @setState step: 3
    @_enableForm()

  render: ->
    uploadComponent = `<TransloaditUploadComponent
                        startUpload={this._startUpload}
                        finishedUpload={this.finishedUpload}
                      />`
    currentComponent = switch @state.step
      when 1
        uploadComponent

      # TODO: some sort of design/text directive for click to edit
      when 2
        srcURL = this.avatarRemoteUrl || this.props.avatarUrl
        `<div>
           <img src={srcURL}/>
           {uploadComponent}
        </div>`

      when 3
        srcURL = this.avatarRemoteUrl || this.props.avatarUrl
        `<div>
           <img src={srcURL}/>
        </div>`

  _disabledClassName: ->
    "#{@props.avatarFormSelector.replace(/^\./, "")}--disabled"

  _startUpload: ->
    @_disableForm()

  _catchSubmission: (e) ->
    e.preventDefault()

  _disableForm: ->
    @$form
      .on("submit", @_catchSubmission)
      .addClass(@_disabledClassName())

  _enableForm: ->
    @$form
      .off("submit", @_catchSubmission)
      .removeClass(@_disabledClassName())

@Sembl.views.avatarView = ($el, el) ->
  React.renderComponent window.Sembl.NewAvatar(
    avatarUrl:          $el.data().avatarUrl,
    avatarFormSelector: $el.data().avatarFormSelector
  ), el



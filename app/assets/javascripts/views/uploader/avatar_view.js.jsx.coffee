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
  
  # Click to upload a different image
  handleOnClick: -> 
    @setState step: 1

  finishedUpload: (results) ->
    @avatarRemoteUrl = results[':original'][0].url
    console.log @avatarRemoteUrl
    $("#profile_remote_avatar_url").val(@avatarRemoteUrl)
    @setState step: 2

  render: ->
    currentComponent = switch @state.step
      when 1
        `<TransloaditUploadComponent
          finishedUpload={this.finishedUpload}
        />`

      #TODO: some sort of design/text directive for click to edit
      when 2
        srcURL = this.avatarRemoteUrl || this.props.avatarUrl
        `<img src={srcURL}/>`

    `<div className="profile__avatar" onClick={this.handleOnClick}>
      {currentComponent}
    </div>`

@Sembl.views.avatarView = ($el, el) ->
  React.renderComponent window.Sembl.NewAvatar(avatarUrl: $el.data().avatarUrl), el



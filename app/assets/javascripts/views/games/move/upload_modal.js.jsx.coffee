#= require views/games/move/gallery_thing_modal
#= require views/games/setup/steps/step_upload

###* @jsx React.DOM ###

# TODO: This is not hooked up to anything

{GalleryThingModal} = Sembl.Games.Move
{StepUpload} = Sembl.Games.Setup

@Sembl.Games.Move.UploadModal = React.createClass
  galleryClickEvent: "move.upload.gallery.click"

  componentDidMount: ->
    $(window).on(@galleryClickEvent, @handleGalleryClick)

  componentWillUnmount: ->
    $(window).off(@galleryClickEvent, @handleGalleryClick)

  handleGalleryClick: (event, thing) ->
    $(window).trigger('modal.open', `<GalleryThingModal thing={thing} />`)

  render: ->
    stepList = ['upload']
    `<StepUpload galleryClickEvent={this.galleryClickEvent} game={this.props.game} />`

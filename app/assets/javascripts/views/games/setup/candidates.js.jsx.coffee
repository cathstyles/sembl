#= require views/games/gallery
#= require views/components/toggle_component

###* @jsx React.DOM ###

{Searcher, ThingModal} = Sembl.Components
{Gallery} = Sembl.Games
{Filter} = Sembl.Games.Setup

@Sembl.Games.Setup.Candidates = React.createClass
  searcherPrefix: 'setup.candidates.searcher'
  galleryPrefix: 'setup.candidates.gallery'

  componentWillMount: ->
    $(window).on("#{@galleryPrefix}.thing.click", @handleThingClick)

  getInitialState: ->
    showGallery: true
    showFilter: true

  handleThingClick: (event, thing) ->
    $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  handleToggleCandidates: ->
    @setState
      showGallery: !@state.showGallery

  render: ->
    filter = if @state.showFilter
      `<Filter ref="filter" filter={this.props.filter} searcherPrefix={this.searcherPrefix}/>`

    gallery = if @state.showGallery
      `<Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />`

    galleryToggle = `
      <button onClick={this.handleToggleCandidates}>
        {this.state.showGallery ? "Hide" : "Show"} candidate images
      </button>`

    `<div>
      <Searcher filter={this.props.filter} prefix={this.searcherPrefix} />
      {filter}
      {galleryToggle}
      {gallery}
    </div>`

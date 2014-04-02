#= require views/components/toggle_component
#= require views/components/searcher
#= require views/games/gallery
#= require views/games/setup/candidates_gallery_modal
#= require views/games/setup/filter

###* @jsx React.DOM ###

{Searcher, ThingModal} = Sembl.Components
{Gallery} = Sembl.Games
{CandidatesGalleryModal, Filter} = Sembl.Games.Setup

@Sembl.Games.Setup.Candidates = React.createClass
  searcherPrefix: 'setup.candidates.searcher'
  galleryPrefix: 'setup.candidates.gallery'

  componentWillMount: ->
    $(window).on("#{@galleryPrefix}.thing.click", @handleThingClick)

  getInitialState: ->
    showGallery: false
    useFilter: false

  handleThingClick: (event, thing) ->
    $(window).trigger('modal.open', `<CandidatesGalleryModal thing={thing} />`)

  handleToggleCandidates: ->
    @setState
      showGallery: !@state.showGallery

  handleFilterRadioChange: (event) ->
    useFilter = (event.target.value == "1")
    @setState 
      useFilter: useFilter
  
  handlePreventDefault: (event) ->
    event.preventDefault()

  render: ->
    filter = if @state.useFilter
      `<Filter ref="filter" filter={this.props.filter} searcherPrefix={this.searcherPrefix}/>`

    gallery = if @state.showGallery
      `<Gallery searcherPrefix={this.searcherPrefix} eventPrefix={this.galleryPrefix} />`

    galleryToggle = `
      <button onClick={this.handleToggleCandidates}>
        {this.state.showGallery ? "Hide" : "Show"} candidate images
      </button>`


    `<div className="setup__candidates">
      <br/>
      <form onSubmit={this.handlePreventDefault}>
        <input checked={!this.state.useFilter} onChange={this.handleFilterRadioChange} id="setup__candidates__filter__radio-no" className="setup__candidates__filter__radio" type="radio" name="filter" value="0"/>
        <label className="setup__candidates__filter__radio-label" htmlFor="setup__candidates__filter__radio-no">
          Include all images as candidates
        </label>
        <br/>
        <input checked={this.state.useFilter} onChange={this.handleFilterRadioChange} id="setup__candidates__filter__radio-yes" className="setup__candidates__filter__radio" type="radio" name="filter" value="1"/>
        <label className="setup__candidates__filter__radio-label" htmlFor="setup__candidates__filter__radio-yes">
          Filter candidate images
        </label>
        
      </form>

      <Searcher filter={this.props.filter} prefix={this.searcherPrefix} />
      {filter}
      {galleryToggle}
      {gallery}
    </div>`

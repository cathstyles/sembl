#= require views/components/thing_modal
#= require views/games/gallery

###* @jsx React.DOM ###

{ThingModal} = Sembl.Components
{Gallery} = Sembl.Games

Checkbox = React.createClass
  handleChange: (event) ->
    @props.handleChange(@props.name, event.target.checked)

  render: () ->
    checked = this.props.checked || false
    className = "setup__steps__filter__#{@props.name}"
    inputId = "#{className}__input"

    `<div className={className}>
      <input id={inputId} type="checkbox" checked={checked} onChange={this.handleChange} />
      <label className="boolean optional control-label" htmlFor={inputId}>{this.props.label}</label>
    </div>`

@Sembl.Games.Setup.StepFilter = React.createClass
  galleryPrefix: "setup.steps.filter.gallery"

  componentWillMount: ->
    $(window).on("#{@props.searcherPrefix}.updated", @handleSearcherUpdated)
    $(window).on("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)

  componentWillUnmount: ->
    $(window).off("#{@props.searcherPrefix}.updated", @handleSearcherUpdated)
    $(window).off("#{@galleryPrefix}.thing.click", @handleGalleryThingClick)

  getInitialState: () ->
    filter: this.props.filter || {}

  handleSearcherUpdated: (event, data) ->
    @setState totalImages: data.results.total
    $(window).trigger('setup.steps.change', {}) # just so that isValid will be checked

  handleGalleryThingClick: (event, thing) ->
    $(window).trigger('modal.open', `<ThingModal thing={thing} />`)

  handleChange: (event) ->
    filter = @state.filter
    filter[event.target.name] = event.target.value
    filter = @state.filter
    this.setState
      filter: filter
    $(window).trigger("#{@props.searcherPrefix}.setFilter", filter)
    $(window).trigger('setup.steps.change', {filter: filter})
    event.preventDefault()

  handleCheckboxChange: (name, checked) ->
    filter = @state.filter
    filter[name] = if checked then 1 else 0
    @setState
      filter: filter
    $(window).trigger("#{@props.searcherPrefix}.setFilter", filter)
    $(window).trigger('setup.steps.change', {filter: filter})

  isValid: ->
    @state.totalImages > 0

  render: () ->
    filter = this.state.filter;
    filterText = if (!filter.text || filter.text == "*") then null else filter.text
    {exclude_mature, exclude_sensitive, include_user_contributed, exclude_fallbacks} = filter

    availableText = (if @state.totalImages? then @state.totalImages else "These") + " images will be available:"

    `<div className="setup__steps__filters">
      <div className="setup__steps__title">Set filters to prioritise or restrict available game images:</div>
      <div className="setup__steps__inner">
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-text">Text:</label>
          <input name="text" className="setup__steps__filters__filter__input" type="text" value={filterText} id="filter-text" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-place">Place:</label>
          <input name="place_filter" className="setup__steps__filters__filter__input" type="text" value={filter.place_filter} id="filter-place" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
        <div className="setup__steps__filters__filter">
          <label className="setup__steps__filters__filter__label" htmlFor="filter-access">Source:</label>
          <input name="access_filter" className="setup__steps__filters__filter__input" type="text" value={filter.access_filter} id="filter-access" onChange={this.handleChange} className="games-setup__filter-input"/>
        </div>
      </div>
      <Checkbox name='exclude_mature' checked={exclude_mature} label="Exclude mature content" handleChange={this.handleCheckboxChange} />
      <Checkbox name='exclude_sensitive' checked={exclude_sensitive} label="Exclude culturally sensitive content" handleChange={this.handleCheckboxChange} />
      <Checkbox name='include_user_contributed' checked={include_user_contributed} label="Include user contributed content" handleChange={this.handleCheckboxChange} />
      <Checkbox name='exclude_fallbacks' checked={exclude_fallbacks} label="Only show images matching these filters" handleChange={this.handleCheckboxChange} />

      <div className="setup__steps__filters__available">{availableText}</div>

      <div className="setup__steps__filters__gallery">
        <Gallery searcherPrefix={this.props.searcherPrefix} eventPrefix={this.galleryPrefix} />
      </div>
    </div>`

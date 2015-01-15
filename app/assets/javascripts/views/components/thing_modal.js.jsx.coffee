###* @jsx React.DOM ###

{classSet} = React.addons

@Sembl.Components.ThingModal = React.createClass

  getInitialState: ->
    showMetadata: false
    zoom: false

  render: () ->
    thing = @props.thing

    dates = thing.general_attributes?['Date/s']
    places = thing.general_attributes?['Places']?.join(', ')
    type = thing.general_attributes?['Node type']

    classes = classSet
      "move__thing-modal": true
      "metadata-is-visible": @state.showMetadata
      "metadata-is-not-visible": !@state.showMetadata
      "modal--large-image-visible": @state.zoom

    metadataToggleClasses = classSet
      "move__thing-modal__attribute-toggle": true
      "move__thing-modal__attribute-toggle--toggled": @state.showMetadata

    attributes = []
    if thing.copyright? && thing.copyright != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
        <div className="move__thing-modal__attribute">
          <h2>Copyright:</h2>
          <span className="move__thing-modal__attribute-text">{thing.copyright}</span>
        </div>
      </div>`
    if thing.attribution? && thing.attribution != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
          <div className="move__thing-modal__attribute">
            <h2>Attribution:</h2>
            <span className="move__thing-modal__attribute-text">{thing.attribution}</span>
          </div>
        </div>`
    if thing.access_via? && thing.access_via != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
          <div className="move__thing-modal__attribute">
            <h2>Access via:</h2>
            <span className="move__thing-modal__attribute-text">{thing.access_via}</span>
          </div>
        </div>`
    if dates? && dates != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
          <div className="move__thing-modal__attribute">
            <h2>Dates:</h2>
            <span className="move__thing-modal__attribute-text">{dates}</span>
          </div>
        </div>`
    if places? && places != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
          <div className="move__thing-modal__attribute">
            <h2>Associated places:</h2>
            <span className="move__thing-modal__attribute-text">{places}</span>
          </div>
        </div>`
    if type? && type != ""
      attributes.push `<div className="move__thing-modal__attribute-row">
          <div className="move__thing-modal__attribute">
            <h2>Type:</h2>
            <span className="move__thing-modal__attribute-text">{type}</span>
          </div>
        </div>`

    metadata = if attributes.length > 0
      `<div>
        <h3 className={metadataToggleClasses}>
          <a href="#togglemetadata" onClick={this._toggleMetadata}>
            {(this.state.showMetadata) ? "Hide" : "Show"} metadata
          </a>
        </h3>
        <div className="move__thing-modal__attributes">
          {attributes}
        </div>
      </div>`
    else
      ""

    thing_link = if thing.item_url
      `<a className='move__thing-modal__title-link' href={thing.item_url} target="_blank">View item</a>`
    else
      ""

    `<div className={classes}>
      <div className="move__thing-modal__wrapper">
        <div className="move__thing-modal__body">
          <a href="#" onClick={this._toggleZoom} className="move__thing-modal__zoom-toggle"><em>Zoom In/Out</em></a>
          <img src={thing.image_browse_url} alt={thing.title} className="move__thing-modal__image move__thing-modal__browse-image" />
          <img src={thing.image_large_url} alt={thing.title} className="move__thing-modal__image move__thing-modal__large-image" />
          <div className="modal__actions">
            {this.props.children}
          </div>
        </div>
        <div className="move__thing-modal__meta">
          <h1 className="move__thing-modal__title">
            {thing.title}
            {thing_link}
          </h1>
          <div className="move__thing-modal__description">
            <div className="move__thing-modal__description__inner">
              <p>{thing.description}</p>
            </div>
          </div>
          {metadata}
        </div>
      </div>
    </div>`

  _toggleZoom: (e) ->
    e.preventDefault()
    @setState
      zoom: !@state.zoom

  _toggleMetadata: (e) ->
    e.preventDefault()
    @setState
      showMetadata: !@state.showMetadata

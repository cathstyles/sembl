###* @jsx React.DOM ###

@Sembl.Components.ThingModal = React.createClass
  render: () ->
    thing = @props.thing
    console.log thing
    `<div className="move__thing-modal">
      <div className="move__thing-modal__wrapper">
        <div className="move__thing-modal__body">
          <img src={thing.image_browse_url} alt={thing.title} className="move__thing-modal__image" />
        </div>
        <div className="move__thing-modal__meta">
          <h1 className="move__thing-modal__title">{thing.title}</h1>
          <p className="move__thing-modal__description">{thing.description}</p>
          <div className="move__thing-modal__attribute-row">
            <div className="move__thing-modal__attribute">
              <h2>Copyright</h2> 
              <p>{thing.copyright}</p>
            </div>
            <div className="move__thing-modal__attribute">
              <h2>Attribution</h2> 
              <p>{thing.attribution}</p>
            </div>
          </div>
          <div className="move__thing-modal__attribute-row">
            <div className="move__thing-modal__attribute">
              <h2>Access via</h2> 
              <p>{thing.access_via}</p>
            </div>
            <div className="move__thing-modal__attribute">
              <h2>Dates</h2> 
              <p>{thing.general_attributes['Date/s']}</p>
            </div>
          </div>
          <div className="move__thing-modal__attribute-row">
            <div className="move__thing-modal__attribute">
              <h2>Associated places</h2> 
              <p>{thing.general_attributes['Places'].join(',')}</p>
            </div>
            <div className="move__thing-modal__attribute">
              <h2>Type</h2> 
              <p>{thing.general_attributes['Node type']}</p>
            </div>
          </div>
        </div>
      </div>
      <div className="modal__actions">
        {this.props.children}
      </div>
    </div>`

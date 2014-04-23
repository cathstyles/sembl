###* @jsx React.DOM ###

@Sembl.Components.ThingModal = React.createClass

  componentDidMount: ->
    $('.move__thing-modal__attributes').hide();
    $('.move__thing-modal__attribute-toggle').click ->
      $(this).toggleClass 'move__thing-modal__attribute-toggle--toggled'
      $('.move__thing-modal__attributes').slideToggle 'fast'

    $('.move__thing-modal__place-button').hover ->
      $('.move__thing-modal__image').toggleClass 'move__thing-modal__image--toggled'


  render: () ->
    thing = @props.thing
    console.log thing

    `<div className="move__thing-modal">
      <div className="move__thing-modal__wrapper">
        <div className="move__thing-modal__body">
          <img src={thing.image_browse_url} alt={thing.title} className="move__thing-modal__image" />
          <div className="modal__actions">
            {this.props.children}
          </div>
        </div>
        <div className="move__thing-modal__meta">
          <h1 className="move__thing-modal__title">{thing.title}</h1>
          <p className="move__thing-modal__description">{thing.description}</p>
          <h3 className="move__thing-modal__attribute-toggle">Show metadata</h3>
          <div className="move__thing-modal__attributes">
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Copyright:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.copyright}</span>
              </div>
            </div>
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Attribution:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.attribution}</span>
              </div>
            </div>
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Access via:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.access_via}</span>
              </div>
            </div>
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Dates:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.general_attributes['Date/s']}</span>
              </div>
            </div>
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Associated places:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.general_attributes['Places'].join(', ')}</span>
              </div>
            </div>
            <div className="move__thing-modal__attribute-row">
              <div className="move__thing-modal__attribute">
                <h2>Type:</h2> 
                <span className="move__thing-modal__attribute-text">{thing.general_attributes['Node type']}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>`

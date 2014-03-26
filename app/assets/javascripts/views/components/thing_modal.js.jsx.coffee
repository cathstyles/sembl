###* @jsx React.DOM ###

@Sembl.Components.ThingModal = React.createClass
  render: () ->
    thing = @props.thing
    `<div className="move__thing-modal">
      <h1 className="move__thing-modal__title">{thing.title}</h1>
      <img src={thing.image_browse_url} alt={thing.title} className="move__thing-modal__image" />
      <div className="move__thing-modal__description">
        <p>{thing.description}</p>
      </div>
      {this.props.children}
    </div>`

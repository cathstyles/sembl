###* @jsx React.DOM ###

@Sembl.Components.ThingModal = React.createClass
  render: () ->
    thing = @props.thing
    `<div className="move__thing-modal">
      <h1>{thing.title}</h1>
      <p>{thing.description}</p>
      <img src={thing.image_browse_url} alt={thing.title} />
      {this.props.children}
    </div>`

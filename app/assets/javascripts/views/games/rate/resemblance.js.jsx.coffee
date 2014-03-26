###* @jsx React.DOM ###

@Sembl.Games.Rate.Resemblance = React.createClass
  render: -> 
    sembl = @props.link.get('viewable_resemblance')
    child = if @props.link.active 
      `<div className="graph__resemblance__filled">{sembl.description}</div>`
    else
      `<div className="graph__resemblance__empty" />`

    `<div className="rate__resemblance">
      {child}
    </div>` 


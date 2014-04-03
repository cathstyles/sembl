###* @jsx React.DOM ###

@Sembl.Games.Rate.Resemblance = React.createClass
  render: -> 
    sembl = @props.link.get('viewable_resemblance')
    scoreClass = @props.link.scoreClass(true) # Use the user supplied rating, not the average. 
    child = if @props.link.active 
      `<div>
        <div className={'graph__resemblance__filled graph__resemblance__filled--' + scoreClass}/>
        <div className="graph__resemblance__expanded">{sembl.description}</div>
      </div>` 
    else
      `<div className="graph__resemblance__empty" />`

    `<div className="rate__resemblance">
      {child}
    </div>` 


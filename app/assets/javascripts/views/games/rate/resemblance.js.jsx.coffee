###* @jsx React.DOM ###

@Sembl.Games.Rate.Resemblance = React.createClass
  render: ->
    sembl = @props.link.get('viewable_resemblance')

    scoreClass = @props.link.scoreClass(true) # Use the user supplied rating, not the average.
    child = if @props.link.active
      `<div>
        <div className={'game__resemblance__filled game__resemblance__filled--' + scoreClass}/>
        <div className="game__resemblance__expanded">
          <div className="game__resemblance__expanded__inner">
            {sembl.description}
          </div>
        </div>
      </div>`
    else
      `<div className="game__resemblance__empty" />`

    `<div className="rate__resemblance">
      {child}
    </div>`


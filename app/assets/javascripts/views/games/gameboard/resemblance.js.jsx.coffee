#= require jquery

###* @jsx React.DOM ###

@Sembl.Games.Gameboard.Resemblance = React.createClass
  handleClick: (event) ->
    $(event.target).parent().toggleClass('game__resemblance__expanded--sticky')

  render: () ->
    resemblance = @props.link.get('viewable_resemblance')
    scoreClass = @props.link.scoreClass()

    child = if resemblance?.description
      `<div>
        <div className={'game__resemblance__filled game__resemblance__filled--' + scoreClass} />
        <div className="game__resemblance__expanded">
          <div className="game__resemblance__expanded__inner" onClick={this.handleClick}>
            {resemblance.description}
          </div>
        </div>
      </div>`
    else
      `<div className="game__resemblance__empty" />`

    `<div className="game__resemblance">
      {child}
    </div>`


#= require jquery

###* @jsx React.DOM ###

@Sembl.Games.Gameboard.Resemblance = React.createClass
  handleClick: (event) ->
    $(event.target).next(".game__resemblance__expanded").toggleClass('hidden')

  render: () ->
    resemblance = @props.link.get('viewable_resemblance')
    scoreClass = @props.link.scoreClass()

    child = if resemblance?.description 
      `<div>
        <div className={'game__resemblance__filled game__resemblance__filled--' + scoreClass}/>
        <div className="game__resemblance__expanded hidden">{resemblance.description}</div>
      </div>` 
    else
      `<div className="game__resemblance__empty" />`

    `<div className="game__resemblance" onClick={this.handleClick}>
      {child}
    </div>`


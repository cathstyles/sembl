#= require jquery

###* @jsx React.DOM ###

@Sembl.Games.Gameboard.Resemblance = React.createClass
  handleClick: (event) ->
    $(event.target).next(".graph__resemblance__expanded").toggleClass('hidden')

  render: () ->
    resemblance = @props.link.get('viewable_resemblance')
    scoreClass = @props.link.scoreClass()

    child = if resemblance?.description 
      `<div>
        <div className={'graph__resemblance__filled graph__resemblance__filled--' + scoreClass}/>
        <div className="graph__resemblance__expanded hidden">{resemblance.description}</div>
      </div>` 
    else
      `<div className="graph__resemblance__empty" />`

    popup = 

    `<div className="board__resemblance" onClick={this.handleClick}>
      {child}
    </div>`


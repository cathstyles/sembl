###* @jsx React.DOM ###

@Sembl.Games.Rate.NavigationView = React.createClass
  handleNext: ->
    @props.handleNext()

  handleBack: ->
    @props.handleBack()

  render: ->
    # resemblances = @props.moves.resemblances()
    currentResemblance = @props.currentLink.get('viewable_resemblance')

    spots = []
    @props.moves.each (move, i) ->
      move.links.each (link, i) ->
        sembl = link.get('viewable_resemblance')
        className = if link.active  then "rating__nav__link--current" else ""
        spots.push `<li className={'rating__nav__link ' + className} key={sembl.id}>
          <span><i className="fa fa-circle"></i></span>
        </li>`

    backBtn = `<div className="rating__nav__back" onClick={this.handleBack}>
        <i className="fa fa-chevron-left"></i>
        Back
     </div>`

    if currentResemblance.rating?
      nextBtn = `<div className="rating__nav__next" onClick={this.handleNext}>
        Go to the next Sembl
        <i className="fa fa-chevron-right"></i>
       </div>`
    else
      nextBtn = `<div className="rating__nav__next rating__nav__next--disabled">
        Go to the next Sembl
        <i className="fa fa-chevron-right"></i>
       </div>`

    `<div className="game__status">
      <div className="game__status-inner">
        <div className="rating__nav">
          {backBtn}
          <ul className="rating__nav__links">{spots}</ul>
           {nextBtn}
          <p className="rating__nav__next-text">Done rating?</p>
        </div>
      </div>
    </div>`

###* @jsx React.DOM ###

@Sembl.Games.Rate.NavigationView = React.createClass
  handleNext: (event) ->
    event?.preventDefault()
    @props.handleNext()

  handleBack: (event) ->
    event?.preventDefault()
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

    backBtn = if @props.combinedIndex > 0
      `<a href="#back" className="rating__nav__back" onClick={this.handleBack}>
          <i className="fa fa-chevron-left"></i>
          Previous Sembl
       </a>`
    else
      `<div className="rating__nav__back rating__nav__back--disabled">
          <i className="fa fa-chevron-left"></i>
          Previous Sembl
       </div>`
    nextBtnText = if @props.totalLinks <= @props.combinedIndex
      "Finish rating"
    else
      "Go to the next Sembl"
    nextBtn = if currentResemblance.rating?
      `<a href="#next" className="rating__nav__next" onClick={this.handleNext}>
        {nextBtnText}
        <i className="fa fa-chevron-right"></i>
       </a>`
    else
      `<div className="rating__nav__next rating__nav__next--disabled">
        {nextBtnText}
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

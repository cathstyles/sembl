###* @jsx React.DOM ###

@Sembl.Games.Rate.NavigationView = React.createClass
  handleNext: -> 
    @props.handleNext()

  handleBack: -> 
    @props.handleBack()

  
  # handleRatingSaved: -> 
  #   $el = $(@getDOMNode())
  #   $el.find('.rating__nav__next').removeClass('rating__nav__next--disabled')
  #   console.log 'rating saved'

  # componentWillMount: ->
  #   $(window).on('ratings:rating_saved', @handleRatingSaved)

  # componentWillUnmount: ->
  #   $(window).off('ratings:rating_saved')
    
  render: ->
    resemblances = @props.moves.resemblances()
    currentResemblance = @props.currentLink.get('viewable_resemblance')

    spots = _.map resemblances, (sembl) ->
      className = if currentResemblance.id == sembl.id  then "rating__nav__link--current" else ""
      `<li className={'rating__nav__link ' + className} key={sembl.id}>
        <a href="#"><i className="fa fa-circle"></i></a>
      </li>`
    
    backBtn = `<div className="rating__nav__back" onClick={this.handleBack}>
        <i className="fa fa-chevron-left"></i>
        Back 
     </div>`

    if currentResemblance.rating? 
      nextBtn = `<div className="rating__nav__next" onClick={this.handleNext}>
        Next 
        <i className="fa fa-chevron-right"></i>
       </div>`
    else
      nextBtn = `<div className="rating__nav__next rating__nav__next--disabled">
        Next 
        <i className="fa fa-chevron-right"></i>
       </div>`
  
    `<div className="rating__nav">
      {backBtn}
      <ul className="rating__nav__links">{spots}</ul>
      {nextBtn}
    </div>`
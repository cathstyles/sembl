###* @jsx React.DOM ###

@Sembl.Games.Rate.NavigationView = React.createClass
  handleNext: -> 
    @props.handleNext()
    
  render: -> 
    resemblances = @props.moves.resemblances()
    currentResemblance = @props.currentLink.get('viewable_resemblance')
    console.log currentResemblance
    console.log resemblances
    
    spots = _.map resemblances, (sembl) ->
      className = if currentResemblance.id == sembl.id  then "current" else ""
      `<li className={className} key={sembl.id}>*</li>`
    

    `<div className="rating__nav">
      <ul className="rating__nav__links">{spots}</ul>
      <div className="rating__nav__next" onClick={this.handleNext}>Next</div>
    </div>`
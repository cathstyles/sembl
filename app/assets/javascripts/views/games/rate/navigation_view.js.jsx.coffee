###* @jsx React.DOM ###

@Sembl.Games.Rate.NavigationView = React.createClass
  handleNext: -> 
    @props.handleNext()
    
  render: -> 
    resemblances = @props.moves.resemblances()
    currentResemblance = @props.currentResemblance
    
    spots = _.map resemblances, (sembl) ->
      className = currentResemblance.id == sembl.id ? "current" : ""
      `<li className={className} key={sembl.id}>*</li>`
    

    `<div className="rating__nav">
      <ul className="rating__nav__links">{spots}</ul>
      <div className="rating__nav__next" onClick={this.handleNext}>Next</div>
    </div>`
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
      console.log sembl.id
      className = if currentResemblance.id == sembl.id  then "rating__nav__link--current" else ""
      `<li className={'rating__nav__link ' + className} key={sembl.id}>
        <a href="#"><i className="fa fa-circle"></i></a>
      </li>`
    

    `<div className="rating__nav">
      <ul className="rating__nav__links">{spots}</ul>
      <div className="rating__nav__next" onClick={this.handleNext}>Next <i className="fa fa-chevron-right"></i></div>
    </div>`
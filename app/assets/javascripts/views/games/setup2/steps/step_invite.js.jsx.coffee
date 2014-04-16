###* @jsx React.DOM ###

@Sembl.Games.Setup.StepDescription = React.createClass
  # TODO: perhaps steps need extra actions? or need to override the next? 
  # or after choosing invitations we have a invite results page which says what happened?

  isValid: ->
    true

  render: ->
    `<div className="setup__steps__invite">
      Invite some players to your game, enter an email address etc..
    </div>`

#= require views/games/setup/players_search
###* @jsx React.DOM ###

@Sembl.Games.Setup.PlayerConfirmed = React.createClass
  className: "games-setup__player-confirmed"

  render: () ->
    tick = "\u2713"
    cross = "\u2718"
    `<div className={this.className}>{this.props.confirmed ? tick : cross}</div>`

{PlayerConfirmed,PlayersSearch} = Sembl.Games.Setup
@Sembl.Games.Setup.Players = React.createClass
  className: "games-setup__players"
  render: () ->
    players_data = [
      {
        username: "michaelhoney",
        email: "michael@icelab.com.au",
        confirmed: true
      },
      {
        username: "narinda",
        email: "narinda@icelab.com.au",
        confirmed: true
      },
      {
        username: "andymccray",
        email: "andy@icelab.com.au",
        confirmed: false
      }
    ]
    players = players_data.map(
      (player) ->
        `<tr key={player.email}>
          <td>{player.email}</td>
          <td><PlayerConfirmed confirmed={player.confirmed} /></td>
        </tr>`
      )

    `<div className={this.className}>
      <p>3 Players Required</p>
      <table>
        {players}
        <PlayersSearch />
      </table>
    </div>`


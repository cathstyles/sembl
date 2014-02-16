#= require views/games/setup/actions
#= require views/games/setup/metadata
#= require views/games/setup/select_board
#= require views/games/setup/select_players
#= require views/games/setup/select_seed
#= require views/games/setup/settings
###* @jsx React.DOM ###
{Actions, Metadata, SelectPlayers} = @Sembl.Games.Setup

@Sembl.Games.Setup.Root = React.createClass
  className: "games-setup"
  render: () ->
    console.log this.props.game
    title = this.props.game.title
    description = this.props.game.description 
    `<div className={this.className}>
      <Actions />
      <Metadata title={title} description={description} />
    </div>`

@Sembl.views.gamesSetup = ($el, el) ->
  game = $el.data().game
  React.renderComponent(
    Sembl.Games.Setup.Root({game: game})
    el
  )
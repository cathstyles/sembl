#= require views/games/setup/actions
#= require views/games/setup/metadata
#= require views/games/setup/seed
#= require views/games/setup/select_board
#= require views/games/setup/select_players
#= require views/games/setup/settings
###* @jsx React.DOM ###
{Actions, Metadata, Seed, SelectBoard, SelectPlayers, Settings} = @Sembl.Games.Setup

@Sembl.Games.Setup.Root = React.createClass
  className: "games-setup"
  render: () ->
    inputs = this.props.inputs
    `<div className={this.className}>
      <form method="post" action={"/games/" + this.props.game.id}>
        <input name="_method" type="hidden" value="patch" />
        <Seed seed={inputs.seed} />
        <Metadata title={inputs.title} description={inputs.description} />
        <Settings invite_only={inputs.invite_only} allow_keyword_search={inputs.allow_keyword_search} />
        <SelectBoard board={inputs.board} boards={inputs.boards} />
        <SelectPlayers />
        <Actions />
        <input type="submit" />
      </form>
    </div>`

@Sembl.views.gamesSetup = ($el, el) ->
  game = $el.data().game
  inputs = 
    title:
      value: game.title
      form_name: "game[title]"
    description:
      value: game.description 
      form_name: "game[description]"
    board:
      id: game.board.id
      title: game.board.title
      form_name: "game[board_id]"
    boards: _.sortBy game.boards, 'title'
    seed:
      id: game.seed_thing_id
      form_name: "game[seed_id]"
    invite_only:
      value: game.invite_only
      form_name: "game[invite_only]"
    allow_keyword_search:
      value: game.allow_keyword_search
      form_name: "game[allow_keyword_search]"

  console.log game
  React.renderComponent(
    Sembl.Games.Setup.Root({game: game, inputs: inputs})
    el
  )
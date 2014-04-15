#= require views/games/setup2/form

###* @jsx React.DOM ###

{Form} = Sembl.Games.Setup
@Sembl.Games.Setup.Edit = React.createClass
  render: ->
    game = @props.game
    formFields = 
      title: game.get('title')
      description: game.get('description')
      seed: {id: game.get('seed_thing_id')}
      board: game.board
      filter: game.get('filter')
      # TODO: settings

    `<Form className="setup" 
      formFields={formFields}
        game={this.props.game} 
        user={this.props.user} />`

@Sembl.views.setupEdit = ($el, el) ->
  Sembl.game = new Sembl.Game($el.data().game);

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setState 
    body: Sembl.Games.Setup.Edit(game: Sembl.game, user: Sembl.user),
    header: Sembl.Games.HeaderView(model: Sembl.game, title: "Edit Game") 


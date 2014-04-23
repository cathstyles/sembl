#= require views/games/setup/form

###* @jsx React.DOM ###

{Form} = Sembl.Games.Setup
@Sembl.Games.Setup.Edit = React.createClass
  render: ->
    game = @props.game

    `<Form className="setup" 
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


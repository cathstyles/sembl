#= require views/games/setup2/steps
#= require views/games/setup2/meta

###* @jsx React.DOM ###

{Meta, Steps} = Sembl.Games.Setup
@Sembl.Games.Setup.New = React.createClass
  render: ->
    steps = [
      Meta,
      `<div>step 2</div>`,
      `<div>step 3</div>`,
      `<div>step 4</div>`
    ]

    `<Steps steps={steps} />`

@Sembl.views.setupNew = ($el, el) ->
  Sembl.game = new Sembl.Game($el.data().game);

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setState 
    body: Sembl.Games.Setup.New({game: Sembl.game, user: Sembl.user}),
    header: Sembl.Games.HeaderView(model: Sembl.game, title: "New Game") 


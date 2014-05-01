###* @jsx React.DOM ###

@Sembl.views.gameIndex = ($el, el) ->
  html = $el.html()
  header = $el.data().header

  @layout = React.renderComponent(
    Sembl.Layouts.Default()
    document.getElementsByTagName('body')[0]
  )
  @layout.setProps
    body: `<div dangerouslySetInnerHTML={{__html: html}}></div>`,
    header: Sembl.Games.HeaderView(model: Sembl.game, title: header)


###* @jsx React.DOM ###

@Sembl.Games.Setup.StepTitle = React.createClass
  componentDidMount: ->
    titleEl = @refs.title.getDOMNode()
    titleEl.focus()
    # FIXME Standard React events are failing for some reason
    $(titleEl).on "keypress", @handleKeyPress

  getInitialState: ->
    title: @props?.title

  handleChange: (event) ->
    title = @refs.title.getDOMNode().value
    state =
      title: title
    @setState(state)
    $(window).trigger('setup.steps.change', {title: title})

  handleKeyPress: (event) =>
    if event.keyCode == 13
      event.preventDefault()
      $(window).trigger('setup.steps.next')

  isValid: ->
    !!@state?.title

  render: ->
    `<div className="setup__steps__name">
      <div className="setup__steps__title"><label htmlFor="setup__steps__title__input">Now, give your game a name:</label></div>
      <div className="setup__steps__inner">
        <input id="setup__steps__title__input"
          className="setup__steps__title__input"
          ref="title"
          type="text"
          placeholder="E.g. Colonial Connections"
          onChange={this.handleChange}
          defaultValue={this.state.title} />
      </div>
    </div>`

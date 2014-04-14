###* @jsx React.DOM ###

@Sembl.Games.Setup.StepTitle = React.createClass
  componentDidMount: ->
    @refs.title.getDOMNode().focus()

  getInitialState: ->
    title: @props?.title

  handleChange: (event) ->
    state = 
      title: @refs.title.getDOMNode().value
    @setState(state)
    $.doTimeout('debounce.setup.steps.change', 200, @bubbleChange, state)


  bubbleChange: (state) ->
    $(window).trigger('setup.steps.change', state)

  isValid: ->
    !!@state?.title

  render: ->
    `<div className="setup__steps__title">
      <label htmlFor="setup__steps__title__input">Name your game</label>
      <br/>
      <input id="setup__steps__title__input" 
        className="setup__steps__title__input" 
        ref="title"
        onChange={this.handleChange}
        value={this.state.title} />
    </div>`

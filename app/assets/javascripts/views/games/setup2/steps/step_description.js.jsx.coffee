###* @jsx React.DOM ###

@Sembl.Games.Setup.StepDescription = React.createClass
  componentDidMount: ->
    @refs.description.getDOMNode().focus()

  getInitialState: ->
    description: @props?.description

  handleChange: (event) ->
    state = 
      description: @refs.description.getDOMNode().value
    @setState(state)
    $.doTimeout('debounce.setup.steps.change', 200, @bubbleChange, state)


  bubbleChange: (state) ->
    $(window).trigger('setup.steps.change', {description: state.description})

  isValid: ->
    true # description is allowed to be empty

  render: ->
    `<div className="setup__steps__description">
      <label htmlFor="setup__steps__description__input">Give your game a description</label>
      <div className="setup__steps__inner">
        <textarea id="setup__steps__description__textarea" 
          className="setup__steps__description__textarea" 
          ref="description"
          onChange={this.handleChange}
          value={this.state.description} />
      </div>
    </div>`

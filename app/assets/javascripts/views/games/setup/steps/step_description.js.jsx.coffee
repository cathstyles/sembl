###* @jsx React.DOM ###

@Sembl.Games.Setup.StepDescription = React.createClass
  componentDidMount: ->
    @refs.description.getDOMNode().focus()

  getInitialState: ->
    description: @props?.description

  handleChange: (event) ->
    description = @refs.description.getDOMNode().value
    state =
      description: description
    @setState(state)
    $(window).trigger('setup.steps.change', {description: description})

  isValid: ->
    true # description is allowed to be empty

  render: ->
    `<div className="setup__steps__description">
      <div className="setup__steps__title"><label htmlFor="setup__steps__description__input">Give your game a short description:</label></div>
      <div className="setup__steps__inner">
        <textarea id="setup__steps__description__textarea"
          className="setup__steps__description__textarea"
          ref="description"
          onChange={this.handleChange}
          defaultValue={this.state.description} />
      </div>
    </div>`

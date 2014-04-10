###* @jsx React.DOM ###

@Sembl.Games.Setup.StepBoard = React.createClass
  handleChange: (event) ->
    #$.doTimeout('debounce.setup.steps.change', 200, @bubbleChange, state)

  bubbleChange: (state) ->
    $(window).trigger('setup.steps.change', {properties: state, valid: @isValid(state)})

  render: ->
    boards = for board in @props.boards
      `<div key={board.id}>{board}</div>`

    `<div className="setup__steps__board">
      Boards
      {boards}
    </div>`

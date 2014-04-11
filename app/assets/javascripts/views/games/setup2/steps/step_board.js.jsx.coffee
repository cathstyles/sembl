###* @jsx React.DOM ###

@Sembl.Games.Setup.StepBoard = React.createClass
  handleSelectBoard: (board) ->
    console.log board.id, board
    window.board = board
    $(window).trigger('setup.steps.change', {properties: {board: board}, valid: true})

  render: ->
    boards = $.map(@props.boards, (board) =>
      selectBoard = => @handleSelectBoard(board)
      `<div>
        <a key={board.id} href="#" onClick={selectBoard} value={board.id}>{board.get('title')}</a>
      </div>`
    )

    `<div className="setup__steps__board">
      Choose a board
      {boards}
    </div>`

#= require views/games/setup2/thumb_board_graph

###* @jsx React.DOM ###

{ThumbBoardGraph} = Sembl.Games.Setup
@Sembl.Games.Setup.StepBoard = React.createClass
  handleSelectBoard: (board) ->
    $(window).trigger('setup.steps.change', {board: board})

  getInitialState: ->
    selectedBoardId: null

  isValid: ->
    !!@props.board?

  render: ->
    boards = $.map(@props.boards, (board) =>
      selectBoard = (ev) => @handleSelectBoard(board); ev.preventDefault()
      className = "setup__steps__board__item"
      className += " selected" if @props.board?.id == board.id
      `<div className={className} onClick={selectBoard}>
        <a key={board.id} href="#" onClick={selectBoard}>{board.get('title')}</a>
        <ThumbBoardGraph board={board} style={{width: 50, height: 50}} />
      </div>`
    )

    `<div className="setup__steps__board">
      <div className="setup__steps__title">Let&rsquo;s get started! First, choose a board:</div>
      <div className="setup__steps__inner">{boards}</div>
    </div>`

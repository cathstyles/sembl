#= require views/games/setup/thumb_board_graph

###* @jsx React.DOM ###

{ThumbBoardGraph} = Sembl.Games.Setup
@Sembl.Games.Setup.StepBoard = React.createClass
  handleSelectBoard: (board) ->
    $(window).trigger('setup.steps.change', {board: board})

  getInitialState: ->
    selectedBoardId: null

  isValid: ->
    @props.board? && @props.board.id?

  render: ->
    boards = $.map(@props.boards, (board) =>
      selectBoard = (event) =>
        event?.preventDefault()
        @handleSelectBoard(board)
      className = "setup__steps__board__item"
      className += " selected" if @props.board?.id == board.id
      `<a href="#selectboard" className={className} onClick={selectBoard}>
        <div className="setup__steps__board__item__inner">
          <span className="setup__steps__board__title" key={board.id}>{board.get('title')}</span>
          <ThumbBoardGraph board={board} style={{width: 50, height: 50}} />
        </div>
      </a>`
    )

    `<div className="setup__steps__board">
      <div className="setup__steps__title">Let&rsquo;s get started! First, choose a board:</div>
      <div className="setup__steps__inner setup__steps__inner--flush">{boards}</div>
    </div>`

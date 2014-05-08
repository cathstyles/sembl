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
      selectBoard = (ev) => @handleSelectBoard(board); ev.preventDefault()
      className = "setup__steps__board__item"
      className += " selected" if @props.board?.id == board.id
      `<div className={className} onClick={selectBoard}>
        <div className="setup__steps__board__item__inner">
          <a key={board.id} href="#" onClick={selectBoard}>{board.get('title')}</a>
          <ThumbBoardGraph board={board} style={{width: 50, height: 50}} />
        </div>
      </div>`
    )

    `<div className="setup__steps__board">
      <div className="setup__steps__title">Let&rsquo;s get started! First, choose a board:</div>
      <div className="setup__steps__inner setup__steps__inner--flush">{boards}</div>
    </div>`

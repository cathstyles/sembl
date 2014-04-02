###* @jsx React.DOM ###

@Sembl.Games.Setup.SelectGameboardModal = React.createClass
  handleSelectBoard: (board_id) ->
    $(window).trigger('setup.board.selectBoard', {board_id: board_id})
    $(window).trigger('modal.close')

  render: ->
    self = @
    boards = this.props.boards.map((board) -> 
      handleClick = (event) ->
        self.handleSelectBoard(board.id)
      `<li className="setup__board__selection-item" key={board.id}>
        <a href="#" value={board.id} onClick={handleClick}>{board.title}</a>
      </li>`
    )

    `<div className="setup__board__selection-modal">
      <h1>Select Gameboard</h1>
      <ul className={this.className}>{boards}</ul>  
    </div>`
    
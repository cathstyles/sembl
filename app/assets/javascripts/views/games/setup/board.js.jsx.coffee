###* @jsx React.DOM ###

@Sembl.Games.Setup.BoardSelected = React.createClass
  className: "games-setup__board__selected"

  render: () ->
    `<div className={this.className} >
      <img src="http://placehold.it/100x100" className="games-setup__board__selected-image" />
      <span className="games-setup__board__selected-title">{this.props.title}</span>
    </div>`


@Sembl.Games.Setup.BoardSelection = React.createClass
  className: "setup__board__selection"

  render: () ->
    self = this
    boards = this.props.boards.map((board) -> 
      handleClick = (event) ->
        console.log self.props, self.props.selectBoardEvent, {board_id: board.id}
        $(window).trigger(self.props.selectBoardEvent, {board_id: board.id})
        $(window).trigger(self.props.toggleEvent)
        event.preventDefault()
      `<li className="setup__board__selection-item">
        <a href="#" value={board.id} onClick={handleClick}>{board.title}</a>
      </li>`
    )
    `<ul className={this.className}>{boards}</ul>`

{BoardSelected, BoardSelection} = @Sembl.Games.Setup
{ToggleComponent} = @Sembl.Components
@Sembl.Games.Setup.Board = React.createClass
  className: "games-setup__board"

  componentWillMount: ()->
    $(window).on(@events.selectBoardEvent, @handleNewBoard)

  componentWillUnmount: ()->
    $(window).off(@events.selectBoardEvent)

  getInitialState: ->
    id: this.props.board.id
    title: this.props.board.title

  handleNewBoard: (event, data) ->
    console.log 'handle new board'
    board_id = data.board_id
    for board in this.props.boards
      if board.id == board_id
        this.setState 
          id: board.id
          title: board.title
    @handleChooseBoardToggle()

  handleChooseBoardToggle: () ->
    $(window).trigger(@events.toggleEvent)

  events: {
    toggleEvent: 'toggle.setup.board.select'
    selectBoardEvent: 'setup.board.selectBoard'
  }

  render: () ->
    component = ToggleComponent
      ref: "toggle"
      OffClass: BoardSelected
      OnClass: BoardSelection
      toggleEvent: @events.toggleEvent
      selectBoardEvent: @events.selectBoardEvent
      id: this.state.id
      title: this.state.title
      boards: this.props.boards

    `<div className={this.className}>
      <h3 className="games-setup__board-title">Gameboard</h3>
      <div className="games-setup__board-inner"> 
        <a className="games-setup__board-anchor" onClick={this.handleChooseBoardToggle} href="#">Select gameboard <i className="fa fa-caret-down"></i></a>
        {component}
      </div>
    </div>`


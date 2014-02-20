###* @jsx React.DOM ###

@Sembl.Games.Setup.BoardSelected = React.createClass
  className: "games-setup__board__selected"

  render: () ->
    `<div className={this.className} >
      <div>{this.props.title}</div>
      <img src="http://placehold.it/100x100" />
    </div>`


@Sembl.Games.Setup.BoardSelection = React.createClass
  className: "setup__board__selection"

  handleSelectBoard: (board_id) ->
    console.log "click"
    console.log board_id
    this.props.requestChange(board_id)

  render: () ->
    self = this
    boards = this.props.boards.map((board) -> 
      handleClick = (event) ->
        self.handleSelectBoard(board.id)
        event.preventDefault()
      `<li>
        <a href="#" value={board.id} onClick={handleClick}>{board.title}</a>
      </li>`
    )
    `<ul className={this.className}>{boards}</ul>`

{BoardSelected, BoardSelection} = @Sembl.Games.Setup
{ToggleComponent} = @Sembl.Components
@Sembl.Games.Setup.Board = React.createClass
  className: "games-setup__board"

  getInitialState: () ->
    board_id: this.props.board.id
    board_title: this.props.board.title

  handleNewBoard: (board_id) ->
    for board in this.props.boards
      if board.id == board_id
        this.setState 
          board_id: board.id
          board_title: board.title
    this.refs.toggle.handleToggleOff()

  handleChooseBoardToggle: () ->
    component = this.refs.toggle
    if component.state.toggle
      component.handleToggleOff()
    else
      component.handleToggleOn()

  render: () ->
    component = ToggleComponent
      ref: "toggle"
      OffClass: BoardSelected
      OnClass: BoardSelection
      offProps: 
        id: this.state.board_id
        title: this.state.board_title
      onProps:
        boards: this.props.boards
        requestChange: this.handleNewBoard

    `<div className={this.className}>
      <div>CHOOSE GAMEBOARD</div> 
      <button onClick={this.handleChooseBoardToggle}>Choose</button>
      {component}
      <input type="hidden" name={this.props.board.form_name} value={this.state.board_id} />
    </div>`


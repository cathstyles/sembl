#= require views/games/setup/select_gameboard_modal

###* @jsx React.DOM ###

{SelectGameboardModal} = @Sembl.Games.Setup
@Sembl.Games.Setup.Board = React.createClass
  className: "games-setup__board"

  componentWillMount: ()->
    $(window).on('setup.board.selectBoard', @handleNewBoard)

  componentWillUnmount: ()->
    $(window).off('setup.board.selectBoard')

  getInitialState: ->
    id: this.props.board.id
    title: this.props.board.title

  handleNewBoard: (event, data) ->
    board_id = data.board_id
    for board in this.props.boards
      if board.id == board_id
        this.setState 
          id: board.id
          title: board.title
    $(window).trigger('setup.game.change')

  handleOpenModal: () ->
    #$(window).trigger(@events.toggleEvent)
    $(window).trigger("modal.open", `<SelectGameboardModal boards={this.props.boards} />`)

  render: () ->
    `<div className={this.className}>
      <h3 className="games-setup__board-title">Gameboard</h3>
      <div className="games-setup__board-inner"> 
        <a className="games-setup__board-anchor" onClick={this.handleOpenModal} href="#">Select gameboard <i className="fa fa-caret-down"></i></a>
        <div className="games-setup__board__selected" >
          <img src="http://placehold.it/120x120" className="games-setup__board__selected-image" />
          <span className="games-setup__board__selected-title">{this.state.title}</span>
        </div>
      </div>
    </div>`


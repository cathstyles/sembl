class Admin::BoardsController < AdminController
  expose(:boards)
  expose(:board, attributes: :board_params)

  respond_to :html

  def index
    respond_with :admin, boards
  end

  def new
    respond_with :admin, board
  end

  def create
    board.creator = current_user
    board.save

    respond_with :admin, board, location: [:admin, :boards]
  end

  def edit
    respond_with :admin, board
  end

  def update
    board.updator = current_user
    board.save

    respond_with :admin, board, location: [:admin, :boards]
  end

  def destroy
    board.destroy

    respond_with :admin, board, location: [:admin, :boards]
  end

protected

  def board_params
    params.require(:board).permit(:title, :number_of_players)
  end
end

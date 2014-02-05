class Admin::BoardsController < AdminController
  respond_to :html

  def index
    @boards = Board.order("updated_at DESC")
    respond_with :admin, @boards
  end

  def new
    @board = Board.new
    respond_with :admin, @board
  end

  def create
    @board = Board.new(board_params)
    @board.creator = current_user
    @board.save
    respond_with :admin, @board, location: [:admin, :boards]
  end

  def edit
    @board = Board.find(params[:id])
    respond_with :admin, @board
  end

  def update
    @board = Board.find(params[:id])
    @board.update_attributes(board_params)
    @board.updator = current_user
    @board.save
    respond_with :admin, @board, location: [:admin, :boards]
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_with :admin, @board, location: [:admin, :boards]
  end

protected

  def board_params
    params.require(:board).permit(:title, :number_of_players, :nodes_attributes, :links_attributes)
  end
end

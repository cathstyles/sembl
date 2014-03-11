class Api::MovesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :find_game, only: [:round]

  # TODO remove once we turn this back into a post in react.
  def index
    create
  end

  # List of moves to rate. 
  # for_round defaults to current round
  def round
    placements = Placement.for_round(@game)
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with @moves
  end

  #TODO is this being used?
  def show
    @node = Node.find(params[:id])
    respond_with @node
  end

  def create
    game = Game.find(move_params[:game_id])

    move = Move.new(user: current_user)
    move.placement = move_params[:placement]
    move.resemblances = move_params[:resemblances]
    if move.save
      game.player(current_user).create_move
      render json: @move
    else
      render json: @move
    end
  end

  private

  def result(status=nil, notice=nil, alert=nil, errors=nil)
    {
      status: status,
      notice: notice,
      alert:  alert,
      errors: errors
    }
  end

  def move_params
    move = params.require(:move).permit(
      :game_id,
      {
        resemblances: [ :description, :link_id ]
      },
      placement: [:node_id, :thing_id]
    )
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

end

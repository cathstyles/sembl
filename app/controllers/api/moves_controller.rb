class Api::MovesController < ApiController
  respond_to :json

  after_filter :verify_authorized, except: [:round, :show]

  before_filter :authenticate_user!
  before_filter :find_game

  def create
    @move = Move.new(user: current_user)
    @move.placement = move_params[:placement]
    @move.resemblances = move_params[:resemblances]
    authorize @move
    if @move.valid? and @move.save
      @game.player(current_user).create_move
    end
    respond_with @move, :location => api_game_moves_url
  end

  private

  def move_params
    move = params.require(:move).permit(
      :game_id,
      {
        resemblances: [ :description, :link_id, :source_description, :target_description ]
      },
      placement: [:node_id, :thing_id]
    )
    move
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

end

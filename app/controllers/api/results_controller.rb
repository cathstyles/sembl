class Api::ResultsController < ApiController
  respond_to :json

  after_filter :verify_authorized
  before_filter :authenticate_user!
  before_filter :find_game

  # def index
  #   authorize @game
  #   round = @game.current_round
  #   placements = @game.completed? ? Placement.for_round(@game, round) : Placement.for_game(game)
  #   @moves = placements.collect{|p| Move.new(placement: p)}
  #   respond_with :api, @moves
  # end

  def show
    authorize @game
    round = params[:id]
    placements = @game.completed? ? Placement.for_game(@game) : Placement.for_round(@game, round) 
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with :api, @moves
  end

  def awards
    @awards = MedalAwarder.new(@game)
    authorize @awards
    respond_with :api, @awards    
  end

  private 

  def find_game
    @game = Game.find(params[:game_id])
  end
end

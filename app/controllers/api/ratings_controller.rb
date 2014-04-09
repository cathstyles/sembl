class Api::RatingsController < ApiController
  respond_to :json

  after_filter :verify_authorized
  before_filter :authenticate_user!
  before_filter :find_game

  # List of moves to rate. 
  # for_round defaults to current round
  def index
    authorize @game
    placements = Placement.for_round(@game).where('creator_id != ?', current_user.id)
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with @moves
  end

  def create 
    sembl = Resemblance.find(rating_params[:resemblance_id])
    @rating = sembl.rating_by(current_user) || Rating.new(resemblance: sembl, creator: current_user)
    authorize @rating 

    @rating.assign_attributes(rating: rating_params[:rating])
    @rating.save

    respond_with :api, @game, @rating
  end

  private 

  def find_game
    @game = Game.find(params[:game_id])
  end

  def rating_params
    params.require(:rating).permit(:resemblance_id, :rating)
  end

end

class Api::RatingsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  before_filter :find_game

  # List of moves to rate. 
  # for_round defaults to current round
  def index
    placements = Placement.for_round(@game)
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with @moves
  end


  def create 
    sembl = Resemblance.find(rating_params[:resemblance_id])
    rating = sembl.rating_for(current_user)
    rating.destroy if rating

    rating = Rating.new(resemblance: sembl, creator: current_user, rating: rating_params[:rating])
    rating.save

    respond_with rating
  end

  private 

  def find_game
    @game = Game.find(params[:game_id])
  end

  def rating_params
    params.require(:rating).permit(:resemblance_id, :rating)
  end

end

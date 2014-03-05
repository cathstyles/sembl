class Api::RatingsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  before_filter :find_game

  # List of placements (moves) to rate. 
  # for_round defaults to current round
  def round
    placements = Placement.for_round(@game)
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with @moves
  end

  def create 

  end

  private 

  def find_game
    @game = Game.find(params[:id])
  end


end

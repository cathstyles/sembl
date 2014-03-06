class Api::RatingsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  before_filter :find_game

  def create 

  end

  private 

  def find_game
    @game = Game.find(params[:game_id])
  end


end

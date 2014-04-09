class Api::PlayersController < ApplicationController
  respond_to :json

  after_filter :verify_authorized, except: [:show]

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game

  def show
    @player = @game.players.find(params[:id])
    authorize @player
    respond_with @player
  end


  private 
  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end
end
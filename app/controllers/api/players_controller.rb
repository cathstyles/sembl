class PlayersController < ApplicationController
  respond_to :json

  after_filter :verify_authorized, except: [:index, :show]

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game

  def index
    @players = @game.players.playing
    respond_with @players
  end

  def show
    @player = @game.players.find(params[:id])
    respond_with @player
  end

  def end_turn
    
  end

  private 
  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end
end
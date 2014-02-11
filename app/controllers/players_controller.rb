class PlayersController < ApplicationController
  respond_to :json

  after_filter :verify_authorized

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game

  def index
    @players = @game.players.playing
    respond_with @players
  end

  def create 
    # Skip to playing turn, no need for invitation workflow.
    @player = @game.players.build(user: current_user, state: 'playing_turn')
    authorize @player

    @game.join if @game.save
    respond_with @player
  end

  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end
end
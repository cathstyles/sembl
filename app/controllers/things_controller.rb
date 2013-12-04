class ThingsController < ApplicationController
  before_filter :find_game

  def index
    @things = Thing.all.random_fixed_order(@game.random_seed)
  end

private

  def find_game
    @game = Game.find(params[:game_id])
  end
end

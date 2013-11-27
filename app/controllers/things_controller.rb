class ThingsController < ApplicationController

  def index
    @things = Thing.all.random_fixed_order(@game.random_seed)
  end

  private

    def find_game 
      @game = Game.find(params[:game][:id])
    end
end

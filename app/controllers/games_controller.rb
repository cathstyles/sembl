class GamesController < ApplicationController

  respond_to :html

  before_filter :authenticate_user!, only: [:index, :show]
  before_filter :find_game, except: :index

  def index
    @games = {
      open: Game.in_progress.open_to_join,
      participating:  Game.participating(current_user),
      hosted: Game.hosted_by(current_user)
    }

    respond_with @games
  end

  def show
    respond_with @game
  end

  def summary
    respond_with @game
  end 

  private

    def find_game 
      @game = Game.find(params[:game][:id])
    end

end

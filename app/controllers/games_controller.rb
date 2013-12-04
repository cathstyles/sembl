class GamesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game, except: :index

  def index
    @games = {
      open: Game.open_to_join,
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

  def join
    @game.players.build(id: current_user.id)
    @game.save
    respond_with @game
  end

  def create

  end

  def new

  end

  def edit

  end

  def update

  end

private

  def find_game
    @game = Game.find(params[:id])
  end
end

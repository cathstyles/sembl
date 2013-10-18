class GameController < ApplicationController

  def index
    @open_games = Game.in_progress.open
    @current_games = Game.in_progress.participating(current_user)

    @completed_games = Game.completed.participating(current_user)
    @hosted_games = Game.hosted_by(current_user)
  end

  def create

  end

  def new

  end

  def summary

  end

  def show

  end


end

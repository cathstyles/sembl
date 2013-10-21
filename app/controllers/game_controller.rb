class GameController < ApplicationController

  expose(:open_games) { Game.in_progress.open }
  expose(:current_games) { Game.in_progress.participating(current_user) }
  expose(:completed_games) { Game.completed.participating(current_user) }
  expose(:hosted_games) { Game.hosted_by(current_user) }


  def summary

  end

end

# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      default("completing_turn")
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  # Player can end turn if they have entered one or more resemblances 
  # for the current round
  def can_end_turn?
    game.links.
    joins(:target).
    joins(:resemblances).
    where("nodes.round = ?", [game.current_round]).
    where("resemblances.creator_id = ?", [user.id]).
    present?
  end
end

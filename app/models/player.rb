# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float            default(0.0), not null
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      default(""), not null
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  state_machine initial: :completing_turn do 

    after_transition :completing_turn => :waiting, do: :check_turn_completion
    after_transition :rating => :wating, do: :check_rating_completion

    event :end_turn do 
      transition :playing => :waiting, 
        if: lambda {|player|  player.completed_requirements? }
    end

    event :begin_rating do 
      transition :waiting => :rating
    end

    event :end_rating do 
      transition :rating => :waiting
    end

    event :begin_turn do 
      transition :waiting => :completing_turn
    end

  end

  def check_turn_completion
    if game.players.with_state(:finished_turn) == game.board.number_of_players
      game.turns_completed
    end
  end

  def check_rating_completion
    if game.players.with_state(:finished_rating) == game.board.number_of_players
      game.ratings_completed
    end
  end

  # Player can end turn if they have entered one or more resemblances 
  # for the current round
  def completed_requirements?
    game.links.
    joins(:target).
    joins(:resemblances).
    where("nodes.round = ?", [game.current_round]).
    where("resemblances.creator_id = ?", [user.id]).
    present?
  end
end

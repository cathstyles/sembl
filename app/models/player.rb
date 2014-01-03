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
#  state      :string(255)      not null
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  after_create :allocate_first_node

  state_machine initial: :draft do 
    after_transition :playing_turn => :waiting, do: :check_turn_completion
    after_transition :rating => :wating, do: :check_rating_completion
    after_transition :draft => any, do: :send_invitation

    event :invite do 
      transition :draft => :playing_turn, 
        if: lambda {|player| player.user.present? }
      transition :draft => :invited
    end

    event :join do 
      transition :invited => :playing_turn
    end

    event :end_turn do 
      transition :playing_turn => :waiting,
        if: lambda {|player|  player.completed_requirements? }
    end

    event :begin_rating do 
      transition :waiting => :rating
    end

    event :end_rating do 
      transition :rating => :waiting
    end

    event :begin_turn do 
      transition :waiting => :playing_turn
    end

    state :invited do 
      validates_presence_of :email 
    end

    state :playing_turn do 
      validates_presence_of :user
    end 

  end

  def self.playing 
    without_states(:draft, :invited)
  end 

  #TODO record locking.
  def allocate_first_node
    node = game.nodes.with_state(:in_play).where(allocated_to_id: nil).take
    if node 
      node.allocated_to = self.user
      node.save!
    end
  end

  def check_turn_completion
    if game.players.with_state(:finished_turn) == game.number_of_players
      game.turns_completed
    end
  end

  def check_rating_completion
    if game.players.with_state(:finished_rating) == game.number_of_players
      game.ratings_completed
    end
  end

  #TODO: This logic is not right. 
  # A player can end a turn when one more more placements are complete. 
  # A placement is complete when all target sembls have been entered.
  def completed_requirements?
    game.links.
    joins(:target).
    joins(:resemblances).
    where("nodes.round = ?", [game.current_round]).
    where("resemblances.creator_id = ?", [user.id]).
    present?
  end

  def send_invitation
    PlayerMailer.game_invitation(self).deliver
  end
end

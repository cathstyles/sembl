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
  validate :email_or_user_id

  state_machine initial: :draft do 

    after_transition :playing_turn => :waiting, do: :check_turn_completion
    after_transition :rating => :wating, do: :check_rating_completion

    event :invited do 
      transition :draft => :playing_turn, 
        if: lambda {|player| player.user.exists? }
      transition :draft => :invited
    end

    event :join do 
      transition :invited => :playing_turn
    end

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
      transition :waiting => :playing_turn
    end

  end

  #TODO record locking.
  def allocate_first_node
    node = game.nodes.with_state(:in_play).where(allocated_to_id: nil).take
    if node 
      node.allocated_to = self
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

  def email_or_user_id
    if email.blank? || user_id.blank? 
      errors.add(:base, "Must enter a valid email address or Sembl user.")
    end
  end

  def send_invitation
    PlayerMailer.game_invitation(@player).deliver
    invited
  end
end

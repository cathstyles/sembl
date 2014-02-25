# == Schema Information
#
# Table name: nodes
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  round           :integer
#  state           :string(255)
#  allocated_to_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  x               :integer          default(0), not null
#  y               :integer          default(0), not null
#

class Node < ActiveRecord::Base
  validates_presence_of :round
  validates_numericality_of :round
  
  belongs_to :game
  has_many :target_links, class_name: "Link", foreign_key: "target_id"
  has_many :source_links, class_name: "Link", foreign_key: "source_id"
  has_many :placements, dependent: :destroy, autosave: true
  belongs_to :allocated_to, class_name: "User"

  before_create :assign_initial_node_states

  # == States 
  #   locked
  #   in_play
  #   filled
  state_machine do 
    event :unlock do 
      transition :locked => :in_play, if: lambda { |node| node.round == node.game.current_round }
    end 

    event :fill do
      transition :in_play => :filled
    end
  end

  def player_placement(user)
    placements.with_state(:proposed).where(creator: user).take
  end

  def final_placement
    placements.with_state(:final).take
  end 

  def viewable_placement(user)
    final_placement || player_placement(user)
  end

  def available_to?(user)
    game.participating?(user) && in_play? &&
    (allocated_to?(user) || round > 1)
  end

  def allocated_to?(user)
    allocated_to_id == user.id 
  end

  # == User States 
  #   locked
  #   available
  #   proposed
  #   filled
  def user_state(user)
    # Locked or filled for all
    return state if locked? || filled?

    # Locked for this user 
    return 'locked' unless available_to?(user) 

    # Player has proposed a placement
    return 'proposed' if player_placement(user) 

    # Available to user
    return 'available'
  end

  private 

  def assign_initial_node_states
    self.state = 'locked'
    if round == 0
      self.state = 'filled'
    elsif round == 1
      self.state = 'in_play'
    end
  end
end

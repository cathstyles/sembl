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
  has_many :links
  has_many :placements

  before_validate :assign_initial_node_states

  state_machine do 
    event :unlock do 
      transition :locked => :in_play, if: lambda { |node| node.round == node.game.current_round }
    end 

    event :fill do
      transition :in_play => :filled
    end
  end


  def final_placement
    placements.with_state(:final).take
  end 

  def available_to?(user)
    game.participating?(user) &&
    allocated_to?(user) || (unlocked? && round > 1)
  end

  def allocated_to?(user)
    allocated_to_id == user.id 
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

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

  before_create :assign_initial_node_states

  state_machine do 
    
  end


  def final_placement
    placements.where(state: 'final').take
  end 

  def available_to?(user)
    game.participating?(user) &&
    (game.current_round > 1 || allocated_to_id == user.id)
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

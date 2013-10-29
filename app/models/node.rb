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
#

class Node < ActiveRecord::Base
  validates_presence_of :round
  validates_numericality_of :round
  
  belongs_to :game
  has_many :links
  has_many :placements


  def final_placement
    placements.where(state: 'final').take
  end 
end

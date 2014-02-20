# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  source_id  :integer
#  target_id  :integer
#  game_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Link < ActiveRecord::Base
  belongs_to :game
  belongs_to :source, class_name: Node
  belongs_to :target, class_name: Node
  has_many :resemblances, dependent: :destroy

  # # Link becomes available when the target node has been filled
  # def available_to?(user)
  #   game.participating?(user) &&
  #   target.placements.where(creator: user).present?
  # end

  def round
    target.round
  end

  def player_resemblance(user)
    resemblances.with_state(:proposed).where(creator: user).take
  end

  def final_resemblance
    resemblances.with_state(:final).take
  end 

  def viewable_resemblance(user)
    final_resemblance || player_resemblance(user)
  end
end

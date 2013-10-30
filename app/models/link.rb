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
  belongs_to :source, class: Node
  belongs_to :target, class: Node

  # Link becomes available when the target node has been filled
  def available_to?(user)
    game.participating?(user) &&
    target.placements.where(creator: user).present?
  end
end

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
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
end

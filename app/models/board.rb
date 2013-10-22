# == Schema Information
#
# Table name: boards
#
#  id                :integer          not null, primary key
#  title             :string(255)      not null
#  number_of_players :integer          not null
#  creator_id        :integer
#  updator_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  game_attributes   :text             default("{\"nodes\": [{\"round\": 0}], \"links\": []}"), not null
#

class Board < ActiveRecord::Base
  validates :title, presence: true
  validates :number_of_players, numericality: {greater_than: 0}

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"
end

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
#  nodes_attributes  :json             default([{"round"=>0}]), not null
#  links_attributes  :json             default([]), not null
#

class Board < ActiveRecord::Base
  validates :title, presence: true
  validates :number_of_players, numericality: {greater_than: 0}

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  def title_with_players
    "#{title}: #{number_of_players } players"
  end
end

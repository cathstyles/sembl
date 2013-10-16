class Board < ActiveRecord::Base
  validates :title, presence: true
  validates :number_of_players, numericality: {greater_than: 0}

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"
end

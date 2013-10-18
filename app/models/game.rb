class Game < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :board

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :player 
end

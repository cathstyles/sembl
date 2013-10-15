class Thing < ActiveRecord::Base
  validates :title, :description, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"
end

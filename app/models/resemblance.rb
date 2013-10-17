class Resemblance < ActiveRecord::Base
  validates_presence_of :description
  belongs_to :link
  belongs_to :creator, class_name: "User"

  has_many :ratings
end

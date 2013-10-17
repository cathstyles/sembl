class Placement < ActiveRecord::Base
  belongs_to :node
  belongs_to :thing
  belongs_to :creator, class_name: "User"

end

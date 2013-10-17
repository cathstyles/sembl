class Rating < ActiveRecord::Base
  belongs_to :resemblance
  belongs_to :creator, class_name: "User"

  
end

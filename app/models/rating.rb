# == Schema Information
#
# Table name: ratings
#
#  id             :integer          not null, primary key
#  rating         :float
#  resemblance_id :integer
#  creator_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :resemblance
  belongs_to :creator, class_name: "User"

  
end

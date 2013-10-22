# == Schema Information
#
# Table name: placements
#
#  id         :integer          not null, primary key
#  state      :string(255)      not null
#  thing_id   :integer
#  node_id    :integer
#  creator_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Placement < ActiveRecord::Base
  belongs_to :node
  belongs_to :thing
  belongs_to :creator, class_name: "User"

end

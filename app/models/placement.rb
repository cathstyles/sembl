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
#  title      :string(255)
#

class Placement < ActiveRecord::Base
  belongs_to :node
  belongs_to :thing
  belongs_to :creator, class_name: "User"

  # == States 
  #   proposed
  #   final
  state_machine initial: :proposed do 
    event :reify do 
      transition :proposed => :final
    end
  end

end

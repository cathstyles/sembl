# == Schema Information
#
# Table name: resemblances
#
#  id          :integer          not null, primary key
#  description :text             not null
#  state       :string(255)      not null
#  score       :float
#  link_id     :integer
#  creator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Resemblance < ActiveRecord::Base
  validates_presence_of :description
  belongs_to :link

  # A resemeblance needs two placements, because every resemblance between the same two nodes
  # can have a different target placement. So knowing about the link, and thus the nodes, is not enough.
  belongs_to :source, class_name: "Placement"
  belongs_to :target, class_name: "Placement"

  belongs_to :creator, class_name: "User"

  has_many :ratings

  # == States 
  #   proposed
  #   final
  state_machine initial: :proposed do 
    event :reify do 
      transition :proposed => :final
    end
  end

  

end

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

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

  validate :cannot_belong_to_creator

  def cannot_belong_to_creator
    if creator == resemblance.creator
      errors.add(:base, "You cannot rate your own sembl.")
    end
  end
end

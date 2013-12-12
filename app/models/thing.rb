# == Schema Information
#
# Table name: things
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  description        :text             default("")
#  creator_id         :integer
#  updator_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  attribution        :string(255)
#  item_url           :string(255)
#  copyright          :string(255)
#  general_attributes :json             default([]), not null
#  import_row_id      :string(255)
#  access_via         :string(255)
#  random_seed        :integer
#  suggested_seed     :boolean          default(FALSE)
#

class Thing < ActiveRecord::Base
  include RandomFixedOrderable

  validates :image, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  mount_uploader :image, ImageUploader
end

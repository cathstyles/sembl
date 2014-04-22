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

  belongs_to :creator, class_name: 'User', inverse_of: :created_things
  belongs_to :updator, class_name: 'User', inverse_of: :updated_things

  after_create :add_to_search_index
  after_update :add_to_search_index

  mount_uploader :image, ImageUploader

  def self.filter_keys
    Thing.distinct.pluck("json_object_keys(json_array_elements(general_attributes))")
  end

  def add_to_search_index
    Services.search_service.index(self)
  end
end

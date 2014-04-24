class Profile < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name

  accepts_nested_attributes_for :user

  mount_uploader :avatar, AvatarUploader
end
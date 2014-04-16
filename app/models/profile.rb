class Profile < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name

  mount_uploader :avatar, AvatarUploader
end
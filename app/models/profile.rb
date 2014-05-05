class Profile < ActiveRecord::Base
  belongs_to :user

  accepts_nested_attributes_for :user

  mount_uploader :avatar, AvatarUploader

  def display_name
    self.name || self.user.email
  end
end

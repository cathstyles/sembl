class Profile < ActiveRecord::Base
  belongs_to :user

  accepts_nested_attributes_for :user

  mount_uploader :avatar, AvatarUploader

  def display_name
    if self.name.present?
      self.name
    else
      self.user.email[0]
    end
  end
end

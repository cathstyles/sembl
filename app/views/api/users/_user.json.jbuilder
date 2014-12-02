json.(user, :id, :email, :role)
json.(user.profile, :name, :bio)
json.avatar_thumb user.profile.avatar.try(:thumb).try(:url)
json.avatar_tiny_thumb user.profile.avatar.try(:tiny_thumb).try(:url)
json.admin(user.admin?)
json.power(user.power?)

json.(user, :email, :role)
json.admin(user.admin?)
json.power(user.power?)
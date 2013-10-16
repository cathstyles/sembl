user = User.create! email: "user@example.com", password: "password"

admin = User.create! email: "admin@example.com", password: "password" do |user|
  user.admin = true
end

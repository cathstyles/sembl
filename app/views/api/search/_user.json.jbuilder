json.array! users do |u|
  json.(u, :email, :role)
end
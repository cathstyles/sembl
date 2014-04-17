# we include player email address because only the admin of a game should see these.
json.(player, :id, :email, :state, :move_state, :score)

if player.user
  json.user do
    json.partial! 'api/users/user', user: player.user
  end
end
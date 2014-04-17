json.(player, :id, :state, :move_state, :score)

if player.user
  json.user do
    json.partial! 'api/users/user', user: player.user
  end
end
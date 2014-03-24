json.(player, :id, :state, :move_state, :score)

json.user do
  json.partial! 'api/users/user', user: player.user
end

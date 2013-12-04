json.(player, :state, :score)

json.user do
  json.partial! 'users/user', user: player.user
end

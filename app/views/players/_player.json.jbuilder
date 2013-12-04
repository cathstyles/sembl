json.(player, :state, :score)
json.is_current_user (player.id == current_user.id)
json.user player.user, partial: 'users/user', as: :user
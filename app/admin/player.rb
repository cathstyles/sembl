ActiveAdmin.register Player do
  config.sort_order = "updated_at_desc"

  filter :id

  index do
    id_column
    actions
  end

  show do
    attributes_table do
      row :game do
        link_to player.game.title, admin_game_path(player.game)
      end
      if player.user.present?
        row :user do
          link_to player.user.email, admin_user_path(player.user)
        end
      end
    end
  end
end

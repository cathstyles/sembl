class AddStateChangedAtToPlayers < ActiveRecord::Migration
  def up
    add_column :players, :state_changed_at, :datetime, null: false, default: "NOW()"

    Player.find_each do |player|
      player.update_column :state_changed_at, player.updated_at
    end
  end

  def down
    remove_column :players, :state_changed_at
  end
end

class AddStateChangedAtToGames < ActiveRecord::Migration
  def up
    add_column :games, :state_changed_at, :datetime, null: false, default: "NOW()"

    Game.find_each do |game|
      game.update_column :state_changed_at, game.updated_at
    end
  end

  def down
    remove_column :games, :state_changed_at
  end
end

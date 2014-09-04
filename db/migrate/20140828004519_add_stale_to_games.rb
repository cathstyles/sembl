class AddStaleToGames < ActiveRecord::Migration
  def change
    add_column :games, :stale, :boolean, default: false
  end
end

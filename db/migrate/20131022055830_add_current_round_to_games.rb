class AddCurrentRoundToGames < ActiveRecord::Migration
  def change
    add_column :games, :current_round, :integer, default: 1
  end
end

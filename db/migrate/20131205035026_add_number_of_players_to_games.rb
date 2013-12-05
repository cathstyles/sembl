class AddNumberOfPlayersToGames < ActiveRecord::Migration
  def change
    add_column :games, :number_of_players, :integer
  end
end

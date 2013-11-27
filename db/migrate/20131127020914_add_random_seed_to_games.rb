class AddRandomSeedToGames < ActiveRecord::Migration
  def change
    add_column :games, :random_seed, :integer

    Game.reset_column_information

    Game.find_each do |game|
      game.random_seed = SecureRandom.random_number(2147483646)
      game.save!
    end 
  end
end

class ChangeRandomSeedOnThings < ActiveRecord::Migration
  def change
    remove_column :things, :random_seed
    add_column :things, :random_seed, :integer

    Thing.reset_column_information

    Thing.find_each do |thing|
      thing.random_seed = SecureRandom.random_number(2147483646)
      thing.save!
    end
  end
end

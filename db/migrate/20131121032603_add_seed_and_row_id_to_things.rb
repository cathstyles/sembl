class AddSeedAndRowIdToThings < ActiveRecord::Migration
  def change
    add_column :things, :import_row_id, :string
    add_column :things, :random_seed, :string
  end
end

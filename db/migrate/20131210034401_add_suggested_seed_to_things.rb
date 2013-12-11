class AddSuggestedSeedToThings < ActiveRecord::Migration
  def change  
    add_column :things, :suggested_seed, :boolean, default: false
  end
end

class AddStateToGames < ActiveRecord::Migration
  def change
    add_column :games, :state, :string, default: "draft"
  end
end

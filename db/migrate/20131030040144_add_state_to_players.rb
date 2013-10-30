class AddStateToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :state, :string, default: "completing_turn"
  end
end

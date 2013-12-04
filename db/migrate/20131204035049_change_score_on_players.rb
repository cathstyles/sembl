class ChangeScoreOnPlayers < ActiveRecord::Migration
  def change
      change_column :players, :score, :float, null: false, default: 0
  end
end

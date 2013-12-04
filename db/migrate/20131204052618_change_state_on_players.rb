class ChangeStateOnPlayers < ActiveRecord::Migration
  def change
    change_column :players, :state, :string, null: false, default: ""
  end
end

class RemoveDefaultStates < ActiveRecord::Migration
  def change
    change_column_default :games, :state, nil
    change_column_default :players, :state, nil
  end
end

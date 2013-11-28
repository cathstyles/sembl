class ChangeCoordinatesOnNode < ActiveRecord::Migration
  def change
      rename_column :nodes, :position_x, :x
      rename_column :nodes, :position_y, :y

      change_column :nodes, :x, :integer, null: false, default: 0
      change_column :nodes, :y, :integer, null: false, default: 0
  end
end

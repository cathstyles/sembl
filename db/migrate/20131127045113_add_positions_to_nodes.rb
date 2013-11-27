class AddPositionsToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :position_x, :float
    add_column :nodes, :position_y, :float
  end
end

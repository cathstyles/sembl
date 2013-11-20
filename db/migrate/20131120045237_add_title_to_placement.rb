class AddTitleToPlacement < ActiveRecord::Migration
  def change
    add_column :placements, :title, :string
  end
end

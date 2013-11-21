class ChangeAttributesOnThings < ActiveRecord::Migration
  def change
    rename_column :things, :attributes, :general_attributes
  end
end

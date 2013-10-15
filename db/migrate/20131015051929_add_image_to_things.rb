class AddImageToThings < ActiveRecord::Migration
  def change
    add_column :things, :image, :string
  end
end
